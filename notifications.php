<?php

// video tutorial - https://youtu.be/WusdpvoIDh4

// execute this file every 10 minutes if you want to check for some new event and send a notification

// command to execute the cron job, it is important to execute this file with PHP7.4 as firebase composer do not support PHP8 yet - php74 notifications.php

// step 1: install firebase for PHP - composer require kreait/firebase-php

// HTTP/1.1 Request demo

// POST /fcm/send HTTP/1.1
// Authorization: key=[YOUR_KEY]
// Content-Type: application/json
// Host: fcm.googleapis.com
// Content-Length: 383

// {
// 	    "to":"[DEVICE_ID]",
//   "notification":
// 	{
// 	  "title": "Demo Title",
// 		"body": "This is only a test!",
// 		"badge": 1,
// 		"sound": "Default",
// 		"image": "https://www.demo.com/image.jpg"
// 	}
// }

require_once 'vendor/autoload.php';

use Kreait\Firebase\Factory;
use Google\Cloud\Core\Timestamp;

// execute this code only from terminal
if (php_sapi_name() == 'cli') {
	$dateToday = new DateTime('today');
	$dateLastFileWasExecuted = new DateTime($cron['Updated']);
	// if file was not executed today then executed it
	if ($dateToday > $dateLastFileWasExecuted) {
		// how to work with the code - https://firebase.google.com/docs/firestore/manage-data/add-data
		$factory = (new Factory())->withServiceAccount('[FIREBASEAUTHFILE].json');
		$dbUri = (new Factory())->withDatabaseUri('https://[PROJECT].firebasedatabase.app/');
		$firestore = $factory->createFirestore();
		$db = $firestore->database();
		$users = $db->collection('users')->documents();
		foreach ($users as $user) {
		    if (!$user->exists()) {
		    	continue;
			}
			$data = $user->data();
			$document = $db->collection('users')->document($user->id())->collection('fcm_tokens');

			$tokensCollection = $db->collection('users/' . $user->id() . '/fcm_tokens')->orderBy('created_at', 'DESC');
			$tokens = $tokensCollection->documents();
			foreach ($tokens as $token) {
			    if (!$token->exists()) {
			    	continue;
			    }
			    $data2 = $token->data();
			    $time = $data2['created_at']->get()->format('Y-m-d H:i:s');

			    $notification = $MYSQL->MSelectOnly('Notifications', 'ID, Updated', "WHERE Email = '" . $user['email'] . "'");
			    if (!empty($notification)) {
			    	$dateFromToken = new DateTime($time);
					$dateFromDB = new DateTime($notification['Updated']);
					if ($dateFromToken > $dateFromDB) {
					    $MYSQL->MInsertOrUpdate('Notifications', "Email = '" . $user['email'] . "', Device = '" . $data2['device_type'] . "', FcmToken = '" . $data2['fcm_token'] . "', Updated = '" . $time . "'", "WHERE Email = '" . $user['email'] . "'");
					}
			    } else {
				    $MYSQL->MInsertOrUpdate('Notifications', "Email = '" . $user['email'] . "', Device = '" . $data2['device_type'] . "', FcmToken = '" . $data2['fcm_token'] . "', Updated = '" . $time . "'", "WHERE Email = '" . $user['email'] . "'");
			    }
			}
		}
	}

	$match = $MYSQL->MSelectOnly('Matches', 'ID, Time, At', 'WHERE Calculated = 0 AND Notification = 0 ORDER BY Time');
	if (!empty($match)) {
		// one hour before the match send notifications
		$dateNow = (new DateTime())->modify('+1 hours');
		$dateMatch = new DateTime($match['Time']);

		if ($dateNow > $dateMatch) {
			$usersForNotify = $MYSQL->MSelectList('Notifications', '*');

			foreach ($usersForNotify as $userN) {
				$predict = $MYSQL->MSelectOnly('Predictions', '*', "WHERE Email = '" . $userN['Email'] . "' AND MatchID = '" . $match['ID'] . "'");
				if (empty($predict)) {
					$text = 'Все още не си дал прогноза за предстоящия мач. Сега е момента.';
				} else {
		            if ($match['At'] == 'at Home' || $match['At'] == 'at St. James\' Park') {
		            	$text = 'Вашата прогноза е ' . $predict['Home'] . ':' . $predict['Away'] . '. Ако желаеш, сега е моментът да я промените.';
					} else {
						$text = 'Вашата прогноза е ' . $predict['Away'] . ':' . $predict['Home'] . '. Ако желаеш, сега е моментът да я промените.';
					}
				}

				$data = ['to' => $userN['FcmToken'], 'notification' => ['title' => 'NUFC Прогнози', 'body' => ($text ?? 'Грешка 323')]];
				$data = json_encode($data);

				// send notification
				$curl = curl_init();

				curl_setopt_array($curl, [
				  CURLOPT_URL => "https://fcm.googleapis.com/fcm/send",
				  CURLOPT_RETURNTRANSFER => true,
				  CURLOPT_ENCODING => "",
				  CURLOPT_MAXREDIRS => 10,
				  CURLOPT_TIMEOUT => 30,
				  CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
				  CURLOPT_CUSTOMREQUEST => "POST",
				  CURLOPT_POSTFIELDS => $data,
				  CURLOPT_HTTPHEADER => [
				    "Authorization: key=[YOUR-KEY]",
				    "Content-Type: application/json"
				  ],
				]);

				$response = curl_exec($curl);
				$err = curl_error($curl);

				curl_close($curl);

				if ($err) {
				  	file_get_contents($_ENV['telegram'] . 'NUFC|Error3232:sorryNoAccess' . $err);
				} else {
					$MYSQL->MInsert('NotificationsLog', "Email = '" . $userN['Email'] . "', Text = '" . $data . "', Response = '" . $response . "', Updated = NOW()");
				}
			}

			// update that notifications have been send
			$MYSQL->MUpdate('Matches', "Notification = 1", 'WHERE ID = ' . $match['ID']);
		}
	}
} else {
	echo 'this file is not run from the terminal';
	exit;
}
