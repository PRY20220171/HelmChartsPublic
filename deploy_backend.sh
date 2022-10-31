####Creacion de chart con rabbitmq
kubectl create namespace rabbitmq
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install mu-rabbit bitnami/rabbitmq --namespace rabbitmq
#Credentials:
#    echo "Username      : user"
#    echo "Password      : $(kubectl get secret --namespace rabbit mu-rabbit-rabbitmq -o jsonpath="{.data.rabbitmq-password}" | base64 -d)"
#    echo "ErLang Cookie : $(kubectl get secret --namespace rabbit mu-rabbit-rabbitmq -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 -d)"
#kubectl port-forward --namespace rabbitmq svc/my-release-rabbitmq 5672:5672
#kubectl port-forward --namespace rabbitmq svc/my-release-rabbitmq 15672:15672
##kubectl port-forward --namespace=rabbitmq --address 0.0.0.0 svc/my-release-rabbitmq 15672 5672 &
##helm list -n rabbit
kubectl -n rabbitmq patch svc my-release-rabbitmq -p '{"spec": {"type": "LoadBalancer"}}'

####Despliegue de los charts con el backend
kubectl create namespace backendapi
set AWS_ACCESS_KEY_ID=AWS_ACCESS_KEY_ID
set AWS_SECRET_ACCESS_KEY=AWS_SECRET_ACCESS_KEY
kubectl create secret docker-registry regcred \
  --docker-server=XXXXXXXXXXXX.dkr.ecr.us-east-1.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password --region us-east-1)
cd ./backend

helm install atencionesapi api-atenciones/ --values values.yaml
helm install authapi api-autentificacion/ --values values.yaml
helm install diagnosticosapi api-diagnosticos/ --values values.yaml
helm install pacientesapi api-pacientes/ --values values.yaml
helm install pruebasapi api-pruebas/ --values values.yaml
helm install resultadosapi api-resultados/ --values values.yaml

#Para desinstalar:
#helm uninstall atencionesapi api-atenciones/ --values values.yaml
#helm uninstall authapi api-autentificacion/ --values values.yaml
#helm uninstall diagnosticosapi api-diagnosticos/ --values values.yaml
#helm uninstall pacientesapi api-pacientes/ --values values.yaml
#helm uninstall pruebasapi api-pruebas/ --values values.yaml
#helm uninstall resultadosapi api-resultados/ --values values.yaml





