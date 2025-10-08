#!/bin/bash
# set -euo pipefail

if [[ -t 1 ]]; then
  BOLD="\033[1m"; DIM="\033[2m"; RED="\033[31m"; GREEN="\033[32m"; YELLOW="\033[33m"; BLUE="\033[34m"; MAGENTA="\033[35m"; CYAN="\033[36m"; RESET="\033[0m"
else
  BOLD=""; DIM=""; RED=""; GREEN=""; YELLOW=""; BLUE=""; MAGENTA=""; CYAN=""; RESET=""
fi

log()      { echo -e "${DIM}$*${RESET}"; }
info()     { echo -e "${BLUE}➜ $*${RESET}"; }
# success()  { echo -e "${GREEN}✔ $*${RESET} $*"; }
warn()     { echo -e "${YELLOW}⚠ $*${RESET}"; }
error()    { echo -e "${RED}✖ $*${RESET}" >&2; exit 1; }
command_exists() { command -v "$1" >/dev/null 2>&1; }

usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "  --patch         Patch the ArgoCD server"
  echo "  --install       Install ArgoCD"
  echo "  --get-password  Get the ArgoCD initial admin password"
  echo "  --help          Display this help message"
  exit "$1"
}

install_argocd() {
  kubectl config set-context proxmox
  kubectl create namespace argocd || true
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
}

patch_argocd() {
    if ! command_exists kubectl; then
        error "kubectl is not installed. Please install it first."
    fi
    info "Patching argocd server w/ load balancer service type"
    kubectl -n argocd patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
}

get_password() {
    SECRET=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
    echo "ArgoCD initial admin password: $SECRET"
    warn "It's recommended to change this password after the initial login."
}

port_forward() {
    info "Starting port-forward to argocd-server on localhost:8080"
    kubectl -n argocd port-forward svc/argocd-server 8080:443
}

if ! command_exists kubectl; then
    error "kubectl is not installed. Please install it first."
fi

case "$1" in
  install_argocd)
    install_argocd
    exit
    ;;
  patch_argocd)
    patch_argocd
    ;;
  get_password)
    get_password
    ;;
  port_forward)
    port_forward
    ;;
  -h | --help | help)
    usage 0
    ;;
  *)
    echo "Unknown command '$1'"
    usage 1
    ;;
esac