# Vagrant Environment

Ce dépôt contient un **Vagrantfile** pour provisionner trois machines virtuelles :

- **web** : serveur web avec Apache2 et PHP
- **bdd** : serveur de base de données MariaDB
- **bastion** : serveur bastion pour accès SSH sécurisé et reverse proxy

---

### Dépendances

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)

Assurez-vous que ces outils sont installés et configurés sur votre machine avant de lancer `vagrant up`.

---

### Auteur

Aguibou Traore

---

### Utilisation

1. Cloner ce dépôt  
2. Lancer la commande `vagrant up` pour créer et configurer les VM  
3. Les machines auront leurs configurations propres (IP, nom, provisioning)  

---
