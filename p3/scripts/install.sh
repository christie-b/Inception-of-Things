# ===============Docker installation===============

# Dependencies
sudo apt update
sudo apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Import Docker GPG key
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg

# Add Docker repo to debian
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

# Docker install
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io -y

# Start service
sudo systemctl enable --now docker

sudo groupadd docker
sudo usermod -aG $USER

# ===============kubectl installation===============

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
# Output must be "kubectl: Ok"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

# ===============k3d installation===============

wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
echo "source <(k3d completion bash)" >> ~/.bashrc

sudo k3d cluster create mycluster
sudo kubectl create namespace dev

sudo kubectl create namespace argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
wget https://github.com/argoproj/argo-cd/releases/download/v2.5.2/argocd-linux-amd64

# Check if cluster is up
# sudo kubectl get nodes

# Check if pods are up
# sudo kubectl get pods -n argocd

# Enable port redirection
# sudo kubectl port-forward -n argocd svc/argocd-server 8080:443 1>/dev/null 2>/dev/null &

# Check the argoCD ui
# firefox https://localhost:8080

# Connect to the argocd app (https://localhost:8080)
# Username: admin
# Get the password
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=”{.data.password}” | sed 's/^.//;s/.$//' | base64 -d
