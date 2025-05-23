# Scripts de provisioning

Ce dossier contient les scripts shell utilisés pour configurer les machines virtuelles :

- `install_web.sh` : installe Apache2, PHP, et configure phpMyAdmin avec connexion à la base distante. Il crée un utilisateur `clientWeb` avec mot de passe `network` et droits sudo
- `install_bdd.sh` : installe MariaDB, crée base de données et utilisateur admin avec tous droits . Il crée un utilisateur `clientWeb` avec mot de passe `network` et droits sudo 
- `install_bastion.sh` : crée utilisateur bastion, configure SSH, installe Apache en reverse proxy, et envoie les clés SSH aux serveurs  

---

### Dépendances

Ces scripts sont conçus pour être utilisés dans un environnement Vagrant avec les dépendances suivantes installées sur la machine hôte :

- [Vagrant](https://www.vagrantup.com/)  
- [VirtualBox](https://www.virtualbox.org/)  

Les scripts installent eux-mêmes les paquets nécessaires dans les VM (apache2, mariadb, sshpass, etc).

---

### Auteur

Aguibou Traore

---

### Utilisation

Chaque script est prévu pour être lancé en tant que provisionnement dans Vagrant, ou manuellement sur la machine cible.

---

### Remarque

Assurez-vous que les dossiers `/vagrant/logs` existent pour permettre la journalisation des actions.

---
