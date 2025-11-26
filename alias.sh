#!/bin/bash

# Drop into ~/.bashrc or ~/.bash_aliases
alias k='kubectl'
alias kc='kubectl config'
alias kn='kubectl config set-context --current --namespace'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgpw='kubectl get pods -o wide'
alias kgs='kubectl get svc'
alias kgd='kubectl get deploy'
alias kgns='kubectl get ns'
alias kgi='kubectl get ingress'
alias kgnodes='kubectl get nodes'
alias kd='kubectl describe' 
alias ka='kubectl apply -f'
alias kl='kubectl logs' 
alias klf='kubectl logs -f'
alias kga='kubectl get all' 
alias kw='watch -n 2 kubectl get pods -o wide'
alias ktop='kubectl top pods'

