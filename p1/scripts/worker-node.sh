echo "Configuring worker node"

echo "Installing kubectl prerequisites..."
cd /etc/yum.repos.d/
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

echo "Installing k3s..."
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -

# sudo service k3s status
# sudo /usr/local/bin/k3s server
# k3s-killall.sh
# sudo /usr/local/bin/kubectl get nodes

echo "Worker configuration done"
