# Environment using Vagrant

## Prerrequisites

- You will need to have installed [Virtualbox](https://www.virtualbox.org/wiki/Downloads).
- You will need to have installed [Vagrant](https://developer.hashicorp.com/vagrant/docs/installation).

## Creating files

Create `Vagrantfile`:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp-education/ubuntu-24-04"
  config.vm.box_version = "0.1.0"

  # microk8s - Single node cluster
  config.vm.define "k8scluster" do |k8scluster|
    k8scluster.vm.hostname = "k8scluster"
    k8scluster.vm.provision "shell", name: "install-microk8s", path: "install-microk8s.sh"
  end
end
```

Create file `install-microk8s.sh` next to `Vagrantfile`.

```bash
# Install kubectl
sudo snap install kubectl --classic --channel=1.30/stable

# Install microk8s via snap
sudo snap install microk8s --classic --channel=1.30/stable

# You may need to configure your firewall to allow pod-to-pod amd pod-to-internet communication, uncomment the following line for this purpose
# sudo ufw allow in on cni0 && sudo ufw allow out on cni0
# sudo ufw default allow routed

# Add vagrant user to microk8s
usermod -aG microk8s vagrant
chown -R vagrant ~/.kube

# Enable addons
microk8s enable dns
microk8s enable dashboard
microk8s enable storage

# Check available versions
# snap info microk8s

# Wait two minutes to get pods deployed
sleep 120

# Echo cluster state
microk8s kubectl get all --all-namespaces

# Configure kubectl
[ -f ~/.kube ] || {
  mkdir .kube
}

cd .kube
microk8s config > config
```

Open a terminal and navigate to the project folder where `Vagrantfile` is located. Execute:

```bash
$ vagrant up
```
