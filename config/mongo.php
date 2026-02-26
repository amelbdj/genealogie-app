<?php
require __DIR__ . '/../vendor/autoload.php';

// 1. Sécurité : Vérifie si le fichier secret existe avant de le lire
$secretPath = '/run/secrets/mongoMDP';
if (!file_exists($secretPath)) {
    die("Erreur : Le secret MongoDB est introuvable dans le conteneur.");
}

$mongoPassword = trim(file_get_contents($secretPath));

// 2. L'URI : Ajoute 'authSource=admin'
// C'est CRUCIAL car l'utilisateur 'root' créé par Docker est dans la base 'admin'
$mongoUri = "mongodb://root:" . rawurlencode($mongoPassword) . "@mongo:27017/?authSource=admin";

try {
    // 3. Connexion avec un timeout pour éviter que PHP ne freeze si le réseau Docker est lent
    $client = new MongoDB\Client($mongoUri, [
        'serverSelectionTimeoutMS' => 5000 // Attend 5 secondes max pour trouver le serveur
    ]);

    // Test de connexion immédiat (pour attraper l'erreur ici et pas plus loin)
    $client->listDatabases(); 

    // Sélection de la base
    $db = $client->genealogie_mongo;
    
} catch (Exception $e) {
    echo "Erreur de connexion à MongoDB : " . $e->getMessage();
    exit;
}
