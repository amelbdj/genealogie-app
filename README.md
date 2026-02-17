# Documentation – Application Généalogie (Docker)

## Architecture Docker de l’application

L’application est composée de deux conteneurs Docker :

* **genealogie_app**
  Application PHP + Apache contenant le code de l’application
  Image : `amelbdj/genealogie-app:v1`

* **genealogie_mongo**
  Base de données MongoDB
  Image officielle : `mongo:6`

Ces deux conteneurs communiquent via un réseau Docker commun (bridge par défaut).
L’application accède à MongoDB via le nom de service `mongo`.

### Schéma simplifié

```
Navigateur (localhost:8080)
        ↓
genealogie_app (PHP/Apache)
        ↓ réseau Docker
genealogie_mongo (MongoDB)
```

---

# Instructions pour construire et démarrer l’application

## Méthode 1 — Avec Docker Compose (recommandé)

### 1. Cloner le projet

```bash
git clone https://github.com/amelbdj/genealogie-app.git
cd genealogie-app
```

### 2. Démarrer les conteneurs

```bash
docker-compose up -d

```

### 3. Accéder à l’application

[http://localhost:8080](http://localhost:8080)

---

# Méthode 2 — Depuis Docker Hub uniquement

Cette méthode fonctionne sans cloner le projet.

### 1. Lancer MongoDB

```bash
docker run -d \
  --name genealogie_mongo \
  -p 27017:27017 \
  mongo:6
```

### 2. Lancer l’application

```bash
docker run -d \
  --name genealogie_app \
  --link genealogie_mongo:mongo \
  -p 8080:80 \
  amelbdj/genealogie-app:v1
```

Application disponible : [http://localhost:8080](http://localhost:8080)

---

# Import des données (obligatoire)

Par défaut la base MongoDB est vide.
Il faut importer les données de test.

### 1. Ouvrir un terminal dans le conteneur app

```bash
docker exec -it genealogie_app bash
```

### 2. Lancer le script d’import

```bash
php scripts/import.php
```

La base MongoDB est maintenant peuplée.
L’application affiche les arbres généalogiques.

---

# Test de la communication entre conteneurs

Vérifier que l’application voit MongoDB :

```bash
docker exec -it genealogie_app bash
php -r "echo gethostbyname('mongo');"
```

Si la communication fonctionne, le conteneur MongoDB répond.

---

# Test de la persistance des données MongoDB

1. Importer les données
2. Redémarrer MongoDB :

```bash
docker restart genealogie_mongo
```

3. Recharger l’application

Les données sont toujours présentes : la persistance fonctionne.

---

# Volumes et stockage

MongoDB utilise un volume Docker :

```
docker volume ls
```

Ce volume permet de conserver les données même si le conteneur est supprimé.

---

# Réseau Docker

Les conteneurs utilisent un réseau bridge :

* genealogie_app
* genealogie_mongo

Le nom `mongo` est utilisé comme hostname dans l’application :

```php
mongodb://mongo:27017
```

---

# Commandes utiles

Voir les conteneurs :

```bash
docker ps
```

Ouvrir un shell dans l’app :

```bash
docker exec -it genealogie_app bash
```

Voir les logs :

```bash
docker logs genealogie_app
```

Arrêter :

```bash
docker compose down
```

---

# Résultat attendu

Après lancement et import :

* Application accessible sur localhost:8080
* Données MongoDB présentes
* Navigation dans les arbres généalogiques fonctionnelle



