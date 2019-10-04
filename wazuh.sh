# Install Wazuh repo
echo Install Wazuh repo
apt update && apt upgrade -y && apt autoremove -y
apt install curl apt-transport-https lsb-release gnupg2 dirmngr sudo expect net-tools -y
if [ ! -f /usr/bin/python ]; then ln -s /usr/bin/python3 /usr/bin/python; fi
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
echo "deb https://packages.wazuh.com/3.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
apt update

# Install Wazuh manager
echo Wazuh manager
apt install wazuh-manager

# Install wazuh api
echo Wazuh api
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt install nodejs -y
apt install wazuh-api -y

# Prevent accidental updates
sed -i "s/^deb/#deb/" /etc/apt/sources.list.d/wazuh.list
apt update

# Install Elastic Stack
echo Elastic Stack
apt install curl apt-transport-https
curl -s https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
apt update
apt install elasticsearch=7.3.2

# Elasticsearch will only listen on the loopback interface (localhost) by default. Configure Elasticsearch to listen to a non-loopback address by editing the file /etc/elasticsearch/elasticsearch.yml and uncommenting the setting network.host. Change the value to the IP you want to bind it to:
# network.host: <elasticsearch_ip>
# Further configuration will be necessary after changing the network.host option. Add or edit (if commented) the following lines in the file /etc/elasticsearch/elasticsearch.yml:
# node.name: <node_name>
# cluster.initial_master_nodes: ["<node_name>"]
#clear
#echo -e "Elasticsearch will only listen on the loopback interface (localhost) by default. \nConfigure Elasticsearch to listen to a non-loopback address by editing the file /etc/elasticsearch/elasticsearch.yml \nand uncommenting the setting network.host. Change the value to the ip of the server. \n"
#echo -e "\nnetwork.host: <elasticsearch_ip>"
my_ip=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
sed -i "s/^#network.host: 192.168.0.1/network.host: $my_ip/" /etc/elasticsearch/elasticsearch.yml

# echo -e "\n \nFurther configuration will be necessary after changing the network.host option. \nUncomment the following lines in the file /etc/elasticsearch/elasticsearch.yml:\n \n# node.name: <node-1> \n# cluster.initial_master_nodes: \n"
sed -i 's/^#node.name: <node-1>/node.name: <node-1>/' /etc/elasticsearch/elasticsearch.yml
sed -i 's/^#cluster\.initial_master_nodes: \["node-1", "node-2"]/cluster.initial_master_nodes: ["node-1"]'/i
# read -p "Press [Enter] to edit /etc/elasticsearch/elasticsearch.yml"
# nano /etc/elasticsearch/elasticsearch.yml

systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service

# Wait for Elastic to start, my server is realy slow, so I'll wait 5 minutes
echo sleeping for 5 minutes
sleep 300
# notes: curl "http://localhost:9200/?pretty"
# curl: (7) Failed to connect to localhost port 9200: Connection refused

# Once Elasticsearch is up and running, it is recommended to load the Filebeat template. Run the following command where Filebeat was installed:
# filebeat setup --index-management -E setup.template.json.enabled=false
# curl https://raw.githubusercontent.com/wazuh/wazuh/3.7/extensions/elasticsearch/wazuh-elastic6-template-alerts.json | curl -XPUT 'http://localhost:9200/_template/wazuh' -H 'Content-Type: application/json' -d @-

# Install Kibana
apt install kibana=7.3.2
sudo -u kibana /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/wazuhapp/wazuhapp-3.10.2_7.3.2.zip

# Kibana will only listen on the loopback interface (localhost) by default, which means that it can be only accessed from the same machine. To access Kibana from the outside make it listen on its network IP by editing the file /etc/kibana/kibana.yml, uncomment the setting server.host, and change the value to:
# server.host: "<kibana_ip>"
# Configure the URLs of the Elasticsearch instances to use for all your queries. By editing the file /etc/kibana/kibana.yml:
# elasticsearch.hosts: ["http://<elasticsearch.hosts>:9200"]
#server.host: "localhost"
# #elasticsearch.hosts: ["http://localhost:9200"]
# sed -i 's/^ 
clear
echo -e "Configure the URLs of the Elasticsearch instances to use for all your queries by editing the file /etc/kibana/kibana.yml: \nUncomment server.host and change the ip. \nAlso set elasticsearch.hosts: [http://<elasticsearch.hosts:9200] to the correct ip \nExit nano by pressing F2 then Y"
read -p "Press [Enter] to edit /etc/kibana/kibana.yml"
nano /etc/kibana/kibana.yml
systemctl daemon-reload
systemctl enable kibana.service
systemctl start kibana.service
echo sleeping for 10 seconds
sleep 10
sed -i "s/^deb/#deb/" /etc/apt/sources.list.d/elastic-7.x.list
apt update
# Set a user and password for your api
clear
echo -e "You need to set a username and password for the Wazuh API."
read -p "Please enter a username : " user
cd /var/ossec/api/configuration/auth
node htpasswd -c user $user
systemctl restart wazuh-api

# OPTIONAL Install reverse https nginx proxy with login crendetials
# Comment exit below with a #
# exit

apt install nginx -y
mkdir -p /etc/ssl/certs /etc/ssl/private
cp <ssl_pem> /etc/ssl/certs/kibana-access.pem
cp <ssl_key> /etc/ssl/private/kibana-access.key
mkdir -p /etc/ssl/certs /etc/ssl/private
openssl req -x509 -batch -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/kibana-access.key -out /etc/ssl/certs/kibana-access.pem
cat > /etc/nginx/sites-available/default <<\EOF
server {
    listen 80;
    listen [::]:80;
    return 301 https://$host$request_uri;
}

server {
    listen 443 default_server;
    listen            [::]:443;
    ssl on;
    ssl_certificate /etc/ssl/certs/kibana-access.pem;
    ssl_certificate_key /etc/ssl/private/kibana-access.key;
    access_log            /var/log/nginx/nginx.access.log;
    error_log            /var/log/nginx/nginx.error.log;
    location / {
        auth_basic "Restricted";
        auth_basic_user_file /etc/nginx/conf.d/kibana.htpasswd;
        proxy_pass http://localhost:5601/;
    }
}
EOF
# remark edit proxypass with correct ip ($my_ip)
apt install apache2-utils -y
clear
echo -e "You need to set a username and password to login."
read -p "Please enter a username : " user
htpasswd -c /etc/nginx/conf.d/kibana.htpasswd $user
systemctl restart nginx
clear
echo "All done! You can login under https://ip_of_yourserver/ \nIf you find any bugs please let me know.\n\n Have fun with Wazuh!"
read -p "Press [Enter] to exit." 

