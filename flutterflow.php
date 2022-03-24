<?php

require 'flutterflowdata.php';

function convertImg(String $source, int $id, String $path) : String {
	// add image to the server
	$type = strtok(pathinfo($source, PATHINFO_EXTENSION), '?');
	$fileName = $id . '.' . $type;
	copy($source, 'imgs/' . $path . '/' . $fileName);

	return $fileName;
}

// data is array type
$data = json_decode(file_get_contents('php://input'), true);

// request is something like this:
// {"uploadImg":"https:\/\/firebasestorage.googleapis.com\/v0\/b\/demoo998899.appspot.com\/o\/users%2F9NxkCDEREsTJoth57c6sZvHoLUf1%2Fuploads%2F1648123749982000.jpeg?alt=media&token=b3514d41-b28e-42f2-8522-fddaeab4be4e","name":"My dog"}
if (!empty($data['uploadImg']) && !empty($data['name'])) {
	// convert to text, JSON_UNESCAPED_UNICODE is for utf8 chars encoding
	$convertToText = json_encode($data, JSON_UNESCAPED_UNICODE);

	// save to log file
	file_put_contents('imgs/posts/log.txt', $convertToText);


	// add image to the server
	$fileName = convertImg($data['uploadImg'], 55, 'posts');

	echo json_encode($fileName);
	exit;
}

if (!empty($data['showImage'])) {
	$img['Image'] = $domain . 'tests/imgs/posts/55.jpeg';

	echo json_encode($img);
	exit;
}

$error['error']['error'] = true;
$error['error']['message'] = 'NO_DATA_FINAL';
echo json_encode($error);
exit;