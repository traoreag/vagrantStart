#!/bin/bash

LOG_FILE="/vagrant/logs/web.log"

echo "[1] Début de la configuration du serveur web"

# Création de clientWeb
id clientWeb &>/dev/null || (useradd -m -s /bin/bash clientWeb && echo "clientWeb:network" | chpasswd && usermod -aG sudo clientWeb)

# Mise à jour des paquets et installation d'Apache, PHP, et utilitaires
apt-get update > "$LOG_FILE" 2>&1
apt-get install -y apache2 php libapache2-mod-php \
  php-cli php-common php-mysql php-zip php-gd php-mbstring \
  php-curl php-xml php-bcmath php-intl php-soap php-readline php-imap \
  php-opcache php-pgsql php-sqlite3 php-json wget unzip \
  >> "$LOG_FILE" 2>&1

# Activation du port 8080 dans Apache
echo "Listen 8080" >> /etc/apache2/ports.conf

# Création du dossier pour phpMyAdmin
mkdir -p /srv/myadmin

# Télécharger et déployer phpMyAdmin
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip -O /tmp/phpmyadmin.zip >> "$LOG_FILE" 2>&1
unzip /tmp/phpmyadmin.zip -d /srv/ >> "$LOG_FILE" 2>&1
mv /srv/phpMyAdmin-*-all-languages/* /srv/myadmin/
rm -rf /srv/phpMyAdmin-*-all-languages /tmp/phpmyadmin.zip

# Copier la config de base de phpMyAdmin
cp /srv/myadmin/config.sample.inc.php /srv/myadmin/config.inc.php

# Modifier le host de connexion à la base de données
sed -i "s/^\(\$cfg\['Servers'\]\[\$i\]\['host'\] = \).*;/\1'192.168.56.82';/" /srv/myadmin/config.inc.php

# Modifier le site par défaut sur le port 80
cat > /etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:80>
    DocumentRoot /var/www/html
</VirtualHost>
EOF

# Config VirtualHost sur le port 8080 pour phpMyAdmin
cat > /etc/apache2/sites-available/myadmin.conf <<EOF
<VirtualHost *:8080>
    DocumentRoot /srv/myadmin
    <Directory /srv/myadmin>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Activer le site et les modules nécessaires
a2ensite myadmin.conf >> "$LOG_FILE" 2>&1
a2enmod rewrite >> "$LOG_FILE" 2>&1
systemctl reload apache2 >> "$LOG_FILE" 2>&1
systemctl restart apache2 >> "$LOG_FILE" 2>&1

echo "[✓] Configuration du serveur web terminée"
