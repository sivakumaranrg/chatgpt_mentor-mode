# KodeKloud lab – Day 1
#setup minikube:
curl -s https://raw.githubusercontent.com/sivakumaranrg/chatgpt_mentor-mode/master/ec2.sh | bash

## Reproduce

kubectl create ns lab
kubectl config set-context --current --namespace=lab
kubectl apply -f deploy/deploy-web.yaml
kubectl apply -f deploy/svc-web.yaml
kubectl set image deploy/web nginx=nginx:1.27
kubectl rollout status deploy/web

## Day 2
kubectl apply -f config/web-configmap.yaml
kubectl apply -f config/web-secret.yaml
kubectl apply -f deploy/deploy-web.yaml
kubectl rollout status deploy/web

## Day 3
- Patched ClusterIP -> NodePort
- Verified external access via $NODE_IP:$NODE_PORT

## Day 4
- Static PV (hostPath) + PVC bound
- Verified persistence across pod recreation
