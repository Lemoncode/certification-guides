#!/bin/bash

echo "Creating $HOME/.vimrc"
cat > ~/.vimrc << EOF
set expandtab
set tabstop=2
set shiftwidth=2
EOF

echo "Configuring $HOME/.bashrc"
cat >> ~/.bashrc << EOF
alias k=kubectl
complete -o default -F __start_kubectl k
EOF

echo "Starting Minikube"
minikube start
