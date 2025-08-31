# Local backend for development - no encryption
# WARNING: you should use encrypted remote backend in production as a 
# best practice. I'm just using local unencrypted for demonstration purposes
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

