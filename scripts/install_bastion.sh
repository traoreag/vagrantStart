#!/bin/bash

LOG_FILE="/vagrant/logs/bastion.log"

echo "[+] Début configuration bastion"

# Création utilisateur bastion
id bastion &>/dev/null || (useradd -m -s /bin/bash bastion && echo "bastion:network" | chpasswd && usermod -aG sudo bastion)

# Installation Apache2 et sshpass
apt-get update -y >> "$LOG_FILE" 2>&1
apt-get install -y apache2 sshpass >> "$LOG_FILE" 2>&1

# Activer modules proxy Apache nécessaires
a2enmod proxy proxy_http >> "$LOG_FILE" 2>&1

# Générer clé SSH si absente
sudo -u bastion bash -c '[ -f ~/.ssh/id_rsa.pub ] || ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa' >> "$LOG_FILE" 2>&1

# Copier clé vers serveurs web et bdd
declare -A servers=( ["192.168.56.81"]="clientweb" ["192.168.56.82"]="clientbdd" )
for ip in "${!servers[@]}"; do
  echo "Copie clé SSH vers ${servers[$ip]}@$ip" | tee -a "$LOG_FILE"
  sudo -u bastion sshpass -p network ssh-copy-id -o StrictHostKeyChecking=no ${servers[$ip]}@$ip >> "$LOG_FILE" 2>&1
done

# Activation du port 8080 dans Apache
echo "Listen 8080" >> /etc/apache2/ports.conf

# Configuration reverse proxy Apache vers web: ports 80 et 8080
cat > /etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:80>
    ProxyPreserveHost On
    ProxyPass / http://192.168.56.81/
    ProxyPassReverse / http://192.168.56.81/
</VirtualHost>
EOF

cat > /etc/apache2/sites-available/myadmin.conf <<EOF
<VirtualHost *:8080>
    ProxyPreserveHost On
    ProxyPass / http://192.168.56.81:8080/
    ProxyPassReverse / http://192.168.56.81:8080/
</VirtualHost>
EOF

# Redémarrage Apache pour prise en compte
a2ensite myadmin.conf >> "$LOG_FILE" 2>&1
a2enmod rewrite >> "$LOG_FILE" 2>&1
systemctl reload apache2 >> "$LOG_FILE" 2>&1
systemctl restart apache2 >> "$LOG_FILE" 2>&1

echo "[✓] Configuration bastion terminée"
