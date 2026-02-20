<?php
require __DIR__ . '/../vendor/autoload.php';

// Récupère le mot de passe depuis le Docker secret
$mongoPassword = trim(file_get_contents('/run/secrets/mongoMDP'));

// Crée l'URI MongoDB avec le mot de passe
$mongoUri = "mongodb://root:$mongoPassword@mongo:27017";

// Connexion au client MongoDB
$client = new MongoDB\Client($mongoUri);

// Sélection de la base
$db = $client->genealogie_mongo;