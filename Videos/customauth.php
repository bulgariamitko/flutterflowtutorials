<?php

// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/watch?v=xIeub_UjGys
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

//no password! as in this case the password is managed by FB
if (!empty($data['pushUser']) && !empty($data['email']) && !empty($data['name'])) {
	$userDB = $_ENV['Mysql']->MSelectOnly('Users', 'UserID', "WHERE Email = '" . $data['email'] . "'");
	if (!empty($data['photo']) && !empty($userDB)) {
		addPicture('Users', $data['photo'], $userDB['UserID']);
	}

	$user = $_ENV['Mysql']->MInsertOrUpdate(
		'Users',
		"Name = '" . htmlspecialchars($data['name']) . "',
		Email = '" . htmlspecialchars($data['email']) . "'",
		"WHERE Email = '" . htmlspecialchars($data['email']) . "'"
	);

	echo json_encode($user ?? []);
	exit;
}

// update last login
if (!empty($data['loginUser']) && !empty($data['email']) && !empty($data['password'])) {
	$user = $_ENV['Mysql']->MSelectOnly('Users', '*', 'WHERE Email = ' . $data['email']);
	if (password_verify($data['password'], $user['Password'])) {
		echo json_encode($user);
		exit;
	} else {
		$error['error']['message'] = 'INVALID_PASSWORD';
		echo json_encode($error);
		exit;
	}
}

// create user
if (!empty($data['createUser']) && !empty($data['email']) && !empty($data['password'])) {
	// create user
}

// lost pass
if (!empty($data['lostPass']) && !empty($data['email'])) {
	$user = $_ENV['Mysql']->MSelectOnly('Users', '*', 'WHERE Email = ' . $data['email']);
	if (!empty($user)) {
		// send email to the user in order to chage the pass
		// echo json_encode($user);
		exit;
	} else {
		$error['error']['message'] = 'NO_USER_FOUND';
		echo json_encode($error);
		exit;
	}
}