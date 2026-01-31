<?php
require __DIR__ . '/../vendor/autoload.php';


$client = new MongoDB\Client("mongodb://mongo:27017");
$db = $client->genealogie_mongo;
