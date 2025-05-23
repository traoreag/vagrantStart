#!/bin/bash

LOG_FILE="/vagrant/logs/bdd.log"

echo "[2] Début de la configuration du serveur BDD"

# Création de clientBdd
id clientBdd &>/dev/null || (useradd -m -s /bin/bash clientBdd && echo "clientBdd:network" | chpasswd && usermod -aG sudo clientBdd)

# Installation de MariaDB
apt-get update > "$LOG_FILE" 2>&1
apt-get install -y mariadb-server mariadb-client >> "$LOG_FILE" 2>&1

# Configurer MariaDB pour accepter les connexions externes
sed -i "s/^bind-address\s*=.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

# Démarrage du service MariaDB
systemctl restart mariadb >> "$LOG_FILE" 2>&1

# Création de l'utilisateur admin, mot de passe 'network', avec tous les droits
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS Reussite;
CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'network';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo "[✓] Configuration du serveur BDD terminée"
