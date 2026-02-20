#!/bin/bash
# import.sh

echo "--- ÉTAPE 1 : Attente du DNS Docker ---"
# Cette boucle s'arrête dès que le nom 'mongo' est reconnu par le réseau
until getent hosts mongo > /dev/null; do
  echo "Le nom 'mongo' n'est pas encore résoluble par Docker... attente 1s"
  sleep 1
done

echo "--- ÉTAPE 2 : Attente du port MongoDB ---"
# Cette boucle s'arrête dès que MongoDB accepte les connexions
while ! timeout 1s bash -c "echo > /dev/tcp/mongo/27017" 2>/dev/null; do
  echo "MongoDB est détecté mais le port 27017 est encore fermé... attente 2s"
  sleep 2
done

echo "--- ÉTAPE 3 : Lancement de l'import PHP ---"
php /var/www/html/scripts/import.php

echo "--- ÉTAPE 4 : Démarrage d'Apache ---"
exec apache2-foreground