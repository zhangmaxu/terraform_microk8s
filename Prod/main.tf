terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}



module "service" {
  source = "../module/service"

  owner         = var.owner
  instance_type = var.instance_type
  key_name      = var.key_name
}
