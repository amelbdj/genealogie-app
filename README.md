# Genealogie App – Conteneurisation Docker

**Genealogie App** est une application web PHP permettant de visualiser des données généalogiques stockées dans une base **MongoDB**.
L’application est entièrement conteneurisée avec **Docker** et orchestrée via **Docker Compose** pour garantir la séparation des services, la persistance des données et la sécurité des communications.

---

C'est une excellente idée. Ajouter ces étapes rend le README totalement autonome pour un nouvel utilisateur.

Voici la section **1. Instructions de démarrage** mise à jour avec les commandes Git et Docker Pull :

---

## 🚀 1. Instructions de démarrage

### Prérequis

* **Git** installé
* **Docker** & **Docker Compose** installés

### Procédure d'installation

1. **Récupérer le projet :**
```bash
git clone https://github.com/amelbdj/genealogie-app.git
cd genealogie-app

```


2. **Récupérer les images depuis Docker Hub :**
```bash
docker pull fatymut/genealogie-app:v3
docker pull mongo:6

```


3. **Configurer la sécurité (Secrets) :**
L'application utilise des Docker Secrets pour ne pas exposer les mots de passe.
```bash
mkdir -p secrets
echo "motdepassemongo" > secrets/mongoMDP.secret

```


4. **Lancer l'infrastructure :**
```bash
docker compose up -d

```


5. **Accéder à l'application :**
Ouvrez votre navigateur sur [http://localhost:8080](https://www.google.com/search?q=http://localhost:8080)

---

### Pourquoi ces étapes ?

* **`git clone`** : Télécharge le fichier `docker-compose.yml` et les scripts de configuration nécessaires.
* **`docker pull`** : Assure que vous avez les dernières versions des images avant de lancer les conteneurs.
* **`secrets/`** : Cette méthode évite d'écrire le mot de passe en clair dans le fichier YAML (bonne pratique de sécurité).



4. **Accéder à l’interface :**
Rendez-vous sur [http://localhost:8080](https://www.google.com/search?q=http://localhost:8080)

> [!INFO]
> **Au démarrage :** Le conteneur MongoDB s'initialise, le conteneur applicatif attend que la base soit prête, un script d'import automatique remplit les données, puis le serveur Apache démarre.

---

## 🏗️ 2. Architecture Docker

### Services

| **app**   | `amelbdj/genealogie-app:v2` | Serveur Web & Logique | PHP, Apache, Extension MongoDB, Script d'import. |
| **mongo** | `mongo:6` | Base de données | Stockage NoSQL, Authentification activée. |

### Configuration Technique

* **Réseau (`app-network`) :** Réseau bridge privé. Le conteneur `app` communique avec la base via le hostname `mongo`.
* **Volumes (`mongo-data`) :** Persistance des données située dans `/data/db` sur le conteneur MongoDB.
* **Secrets (`mongoMDP`) :** Le mot de passe root est monté dans `/run/secrets/mongoMDP`. Il n'est jamais stocké en clair dans l'image ou le code.

---

##  3. Guide de test

### Vérification des conteneurs

```bash
docker ps

```

Vérifiez que `genealogie_app` et `genealogie_mongo` sont en statut *Up*.

### Test de communication interne

Entrez dans le conteneur applicatif et testez la connexion PHP vers MongoDB :

```bash
docker exec -it genealogie_app php -r "require '/var/www/html/config/mongo.php'; echo 'Connexion OK';"

```

### Test de persistance

1. Supprimez le conteneur de base de données : `docker stop genealogie_mongo && docker rm genealogie_mongo`
2. Relancez-le : `docker compose up -d`
3. Rafraîchissez votre navigateur : **Les données sont toujours là** grâce au volume Docker.

---

##  4. Initialisation automatique

Le flux de démarrage est géré par le script `import.sh` (Entrypoint) :

1. **Wait-for-it :** Attente de la disponibilité du port 27017 de MongoDB.
2. **Auth :** Lecture du mot de passe via le Docker Secret.
3. **Import :** Exécution du script PHP d'importation des données initiales.
4. **Run :** Lancement du service Apache en premier plan.

---

##  5. Conformité du projet

* **Conteneurisation :** Backend et base de données isolés.App monolithe donc front et back dans le même conteneur, mais base de données séparée.
* **Orchestration :** Utilisation de Docker Compose (réseaux, volumes, dépendances).
* **Sécurité :** Utilisation de **Docker Secrets** et isolation réseau.
* **Portabilité :** Images disponibles sur Docker Hub, exécution "zero-config" (hors secrets).

---

##  6. Dépôt et Images

* **Docker Hub :** [amelbdj/genealogie-app](https://hub.docker.com/r/amelbdj/genealogie-app)
* **Repository Git :** `[[repo git branch true](https://github.com/amelbdj/genealogie-app/tree/true)]`
