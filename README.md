# Projet Genealogie App

## Description

Cette application permet de gérer et visualiser des arbres généalogiques.

Elle utilise :

* PHP 8.2 + Apache
* MongoDB 6
* Composer pour gérer les dépendances PHP

Toutes les dépendances et le code sont déjà inclus dans l’image Docker `amelbdj/genealogie-app:v1`.

---

## Scénarios de test

### **1. Test rapide avec Docker Compose (recommandé pour le prof)**

Le `docker-compose.yml` de la **branch main** contient uniquement les services nécessaires pour lancer l’application :

* **app** : l’application PHP
* **mongo** : base de données MongoDB

#### Commandes à exécuter

```bash
# Se placer dans le dossier contenant docker-compose.yml (branch main)
docker compose pull       # récupère les images depuis Docker Hub
docker compose up -d      # lance les conteneurs en arrière-plan
docker compose logs -f    # pour suivre les logs
```

#### Accès à l’application

* Ouvrir un navigateur à : `http://localhost:8080`
* MongoDB est exposé sur : `localhost:27017` (optionnel pour inspection)

---

### **2. Test sans Docker Compose**

Si le prof souhaite tester uniquement l’image Docker sans docker-compose :

```bash
# Récupérer les images depuis Docker Hub
docker pull mongo:6
docker pull amelbdj/genealogie-app:v1

# Lancer MongoDB
docker run -d \
  --name genealogie_mongo \
  -p 27017:27017 \
  -v mongo-data:/data/db \
  mongo:6

# Lancer l'application et lier Mongo
docker run -d \
  --name genealogie_app \
  -p 8080:80 \
  --link genealogie_mongo:mongo \
  amelbdj/genealogie-app:v1
```

* Accès : `http://localhost:8080`
* Tout fonctionne sans copier le code local.

---

## Branches du projet

* **main** : contient uniquement le `docker-compose.yml` minimal pour test rapide
* **dev** : contient l’ensemble du projet (code PHP, scripts, Dockerfile, composer.json, etc.)

---

## Notes techniques

* Le fichier `config/mongo.php` utilise :

```php
require __DIR__ . '/../vendor/autoload.php';
```

pour inclure correctement Composer depuis l’image Docker.

* Les dépendances PHP sont déjà installées dans l’image (`composer install` a été exécuté lors du build).
* Apache peut afficher un warning sur le `ServerName` → cela n’impacte pas le fonctionnement.

---

Si tu veux, je peux te **faire la version finale prête à copier-coller dans GitHub**, formatée avec un joli style Markdown et avec toutes les instructions exactement prêtes pour ton prof.

Veux‑tu que je fasse ça ?
