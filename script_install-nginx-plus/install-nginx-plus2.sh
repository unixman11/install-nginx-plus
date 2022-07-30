#!/bin/bash
# ubuntu 18.04 lts work!!!

echo "Cleanup NGINX controller agent."

sudo systemctl stop controller-agent

sudo apt-get purge avrd nginx-plus-module-metrics avrd-libs -y --allow-change-held-packages

sudo apt-get purge nginx-controller-agent -y --allow-change-held-packages

sudo apt autoremove -y

sudo rm -f /etc/apt/sources.list.d/nginx-controller.list

echo "Cleanup old NGINX Plus."

sudo rm -Rf /etc/ssl/nginx
sudo rm -f /etc/ssl/nginx/nginx-repo.*
sudo rm -f /etc/apt/sources.list.d/nginx*
sudo rm -f /etc/apt/apt.conf.d/90pkgs-ngin*

sudo apt-get purge -y --allow-change-held-packages app-protect

sudo apt-get purge -y --allow-change-held-packages nginx-plus-module-*

sudo apt-get purge -y --allow-change-held-packages app-protect-*

sudo apt-get purge -y --allow-change-held-packages nginx-plus*

sudo apt autoremove -y

sudo mkdir /etc/ssl/nginx
sudo cp nginx-repo.crt /etc/ssl/nginx/
sudo cp nginx-repo.key /etc/ssl/nginx/

echo "Install the prerequisites packages."

sudo apt install -y apt-transport-https lsb-release ca-certificates wget gnupg2 ubuntu-keyring

wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | gpg --dearmor | sudo tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null

printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list

printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-app-protect.list

printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] https://pkgs.nginx.com/app-protect-security-updates/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee -a /etc/apt/sources.list.d/nginx-app-protect.list

sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

sudo apt update

sudo apt install -y nginx-plus=24-3~bionic

sudo apt-mark hold nginx-plus

sudo systemctl start nginx.service

sudo systemctl enable nginx.service

sudo apt install -y app-protect=24+3.639.0-1~bionic \
nginx-plus-module-appprotect=24+3.639.0-1~bionic \
app-protect-plugin=3.639.0-1~bionic \
app-protect-engine=8.7.4-1~bionic \
app-protect-common=8.7.4-1~bionic \
app-protect-compiler=8.7.4-1~bionic

sudo apt-mark hold app-protect nginx-plus-module-appprotect app-protect-plugin app-protect-engine app-protect-common app-protect-compiler

# The appprotect dynamic module for nginx has been installed.
# To enable this module, add the following to /etc/nginx/nginx.conf
# and reload nginx:

#    load_module modules/ngx_http_app_protect_module.so;

sudo systemctl restart nginx.service

sudo apt install -y nginx-plus-module-njs=24+0.7.0-1~bionic

# The njs dynamic modules for NGINX Plus have been installed.
# To enable these modules, add the following to /etc/nginx/nginx.conf
# and reload nginx:

#    load_module modules/ngx_http_js_module.so;
#    load_module modules/ngx_stream_js_module.so;

sudo apt-mark hold nginx-plus-module-njs

sudo systemctl restart nginx.service

nginx -v

curl localhost

echo "Install NGINX Plus finished."
