# KodeKloud lab – Day 1

## Reproduce

kubectl create ns lab
kubectl config set-context --current --namespace=lab
kubectl apply -f deploy/deploy-web.yaml
kubectl apply -f deploy/svc-web.yaml
kubectl set image deploy/web nginx=nginx:1.27
kubectl rollout status deploy/web
