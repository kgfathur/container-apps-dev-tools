<?php
if(isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on')   
	$urlProto = "https";   
else  
	$urlProto = "http";

$urlHost = $_SERVER['HTTP_HOST'];
$url = $urlProto . '://' . $urlHost . '/info.php';
$userAgent = $_SERVER['HTTP_USER_AGENT'];
$ipAddress = $_SERVER['SERVER_ADDR'];
$remoteAddress = $_SERVER['REMOTE_ADDR'];
$instanceID = getenv('HOSTNAME'); 
if(empty($instanceID)){
  $instanceID = gethostname();
}
if(strpos($userAgent, 'curl') !== false){
	$newLine = PHP_EOL;
	$phpInfoPage = $url;
} else {
	$newLine = "<br>";
	$phpInfoPage = "<a href='" . $url . "'>" . $url . "</a>";
}

print 'Client Address: ' . $remoteAddress . $newLine;
print 'Server Address: ' . $ipAddress . $newLine;
print 'Access Address: ' . $urlHost . $newLine;
print 'Server Hostname: ' . $instanceID . $newLine;
print 'PHP Info: ' . $phpInfoPage . $newLine;
?>