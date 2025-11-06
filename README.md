# KodeKloud lab – Day 1

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
