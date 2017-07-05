<?php

function HookSlackAllAfterlogin() {

	global $username, $channel_url;

	$data = array(
	    'text'      => $username + " logged in successfully",
	);   

	$content = json_encode($data);

	$curl = curl_init($channel_url);
	curl_setopt($curl, CURLOPT_HEADER, false);
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($curl, CURLOPT_HTTPHEADER,
	        array("Content-type: application/json"));
	curl_setopt($curl, CURLOPT_POST, true);
	curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

	$json_response = curl_exec($curl);
}