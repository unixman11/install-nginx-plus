$script = <<-SCRIPT
sudo mkdir /etc/ssl/nginx
cd /etc/ssl/nginx
sudo cp /tmp/nginx-repo.crt /etc/ssl/nginx/
sudo cp /tmp/nginx-repo.key /etc/ssl/nginx/
sudo wget https://cs.nginx.com/static/keys/nginx_signing.key && sudo apt-key add nginx_signing.key
sudo wget https://cs.nginx.com/static/keys/app-protect-security-updates.key && sudo apt-key add app-protect-security-updates.key
sudo apt-get install apt-transport-https lsb-release ca-certificates
printf "deb https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
printf "deb https://pkgs.nginx.com/app-protect/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
printf "deb https://pkgs.nginx.com/app-protect-security-updates/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee -a /etc/apt/sources.list.d/nginx-app-protect.list
sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
sudo apt-get update
sudo apt-get install -y nginx-plus app-protect app-protect-attack-signatures
nginx -v
rm -f /tmp/nginx-repo*
sudo systemctl enable nginx.service
sudo systemctl start nginx.service
SCRIPT

Vagrant.configure("2") do |config|

  config.vm.define "nginx-plus" do |vm1|
    vm1.vm.box = "ubuntu/bionic64"
    vm1.vm.hostname = "nginx-plus"
    vm1.vm.network "private_network", ip: "192.168.55.120"
    vm1.vm.provision "file", source: "nginx-repo.crt", destination: "/tmp/nginx-repo.crt"
    vm1.vm.provision "file", source: "nginx-repo.key", destination: "/tmp/nginx-repo.key"
    vm1.vm.provision "shell", inline: $script
    vm1.vm.provider "virtualbox" do |vb|
      vb.name = "nginx-plus"
      vb.cpus = 2
      vb.memory = 2048
      #vb.customize ["modifyvm", :id, "--nic1", "natnetwork"]
      #vb.customize ["modifyvm", :id, "--nat-network1", "NatNetwork"]
    end
  end
end
