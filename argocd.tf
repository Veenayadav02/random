provider "kubernetes" {
  config_path = "~/.kube/config"  # Path to your kubeconfig file
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  # Path to your kubeconfig file
  }
}


data "aws_eks_cluster_auth" "main" {
 name = aws_eks_cluster.main.name
}

resource "helm_release" "argocd" {
 depends_on = [aws_eks_node_group.main]
 name       = "argocd"
 repository = "https://argoproj.github.io/argo-helm"
 chart      = "argo-cd"
 version    = "4.5.2"

 namespace = "argocd"

 create_namespace = true

 /*set {
   name  = "server.service.type"
   value = "LoadBalancer"
 }

 set {
   name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
   value = "nlb"
 }*/
}


data "kubernetes_service" "argocd_server" {
 metadata {
   name      = "argocd-server"
   namespace = helm_release.argocd.namespace
 }
}
