helm repo add k8ssandra https://helm.k8ssandra.io/stable
helm repo update
helm repo update
helm repo list
kubectl create namespace database
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml -n database
kubectl apply -f sc.yaml -n database
helm install -f salud.yaml k8ssandra k8ssandra/k8ssandra -n database
#helm upgrade -f salud.yaml k8ssandra k8ssandra/k8ssandra -n database
#helm install -f k8ssandra.yaml k8ssandra k8ssandra/k8ssandra --namespace database
kubectl -n database patch svc k8ssandra-dc1-stargate-service -p '{"spec": {"type": "ClusterIP"}}'
kubectl get svc -n database