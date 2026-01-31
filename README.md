Parfait ! Voici une version **améliorée et prête à montrer à ton prof**, avec toutes les commandes Docker détaillées pour lancer, tester et gérer ton application :

---

````markdown
# Genealogie App

Une application PHP pour gérer et visualiser des arbres généalogiques, connectée à une base de données MongoDB, entièrement déployable via Docker.

---

## Prérequis

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- Compte Docker Hub (optionnel si vous voulez utiliser l’image publique)

---

## Installation du projet

1. **Cloner le projet**

```bash
git clone <ton-repo-git> genealogie-app
cd genealogie-app
````

2. **Lancer les conteneurs avec Docker Compose**

```bash
docker compose up --build
```

* Le conteneur `app` contient PHP 8.2 + Apache + MongoDB extension.
* Le conteneur `mongo` contient MongoDB 6.
* Le projet sera accessible sur [http://localhost:8080](http://localhost:8080)

3. **Vérifier les conteneurs**

```bash
docker compose ps
```

---

## Commandes utiles

### Se connecter au conteneur PHP

```bash
docker compose exec app bash
```

### Installer les dépendances PHP via Composer

*(à l’intérieur du conteneur `app`)*

```bash
composer install
```

### Lancer un script PHP

*(à l’intérieur du conteneur `app`)*

```bash
php scripts/import.php
```

### Arrêter et supprimer les conteneurs

```bash
docker compose down -v
```

* `-v` supprime aussi le volume MongoDB pour repartir à zéro.

---

## Déploiement depuis Docker Hub

L’image est disponible sous :

```
amelbdj/genealogie-app:v1
```

Pour lancer l’application directement depuis Docker Hub sans reconstruire :

```bash
docker pull amelbdj/genealogie-app:v1
docker run -p 8080:80 amelbdj/genealogie-app:v1
```

---

## Structure du projet

```
├── config/           # Configurations PHP, notamment mongo.php
├── scripts/          # Scripts PHP d'import ou de traitement
├── src/              # Code source principal de l’application
├── Dockerfile        # Construction de l’image PHP + Apache
├── docker-compose.yml# Définition des conteneurs et volumes
├── vendor/           # Dépendances installées via Composer
└── README.md         # Ce fichier
```

---

## Notes techniques

* Le projet utilise **Composer** pour la gestion des dépendances.
* L’extension **MongoDB** pour PHP est déjà installée dans le conteneur.
* Les données MongoDB sont persistées grâce au volume Docker `mongo-data`.
* Les chemins dans PHP utilisent `__DIR__` pour inclure correctement les fichiers dans Docker.


```
