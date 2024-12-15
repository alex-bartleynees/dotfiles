#!/bin/bash

# Install kubectl
sudo pacman -S --noconfirm kubectl

# Verify installation
kubectl version --client

# Create kubectl config directory if it doesn't exist
mkdir -p ~/.kube
