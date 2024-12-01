terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Set up the DigitalOcean provider
provider "digitalocean" {
  token = var.digitalocean_api_token
}

variable "digitalocean_api_token" {
  description = "DigitalOcean API token"
  type        = string
}

# Set up the Kubernetes provider using kube_config from the DigitalOcean Kubernetes Cluster resource
provider "kubernetes" {
  host                   = digitalocean_kubernetes_cluster.my_cluster.endpoint
  cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.my_cluster.kube_config[0].cluster_ca_certificate)
  token                  = digitalocean_kubernetes_cluster.my_cluster.kube_config[0].token
}

# Create a DigitalOcean Kubernetes cluster
resource "digitalocean_kubernetes_cluster" "my_cluster" {
  name    = "my-cluster"
  region  = "nyc3"  # Use the region you want (e.g., nyc1, sfo2)
  version = "latest"

  node_pool {
    name       = "default-node-pool"
    size       = "s-1vcpu-2gb"  # Choose the size of your nodes
    node_count = 3
  }
}

# Output the Kubernetes kubeconfig for accessing the cluster
output "kube_config" {
  value = digitalocean_kubernetes_cluster.my_cluster.kube_config[0].raw_config
}

# Create a Kubernetes Deployment for your app
resource "kubernetes_deployment" "my_app" {
  metadata {
    name      = "my-app-deployment"
    namespace = "default"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "my-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app"
        }
      }

      spec {
        container {
          name  = "my-app-container"
          image = "registry.digitalocean.com/devopsolo/your-image-name:latest"  # Updated based on docker-build.yml
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# Create a Kubernetes Service (LoadBalancer) for your app
resource "kubernetes_service" "my_app_service" {
  metadata {
    name      = "my-app-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "my-app"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
