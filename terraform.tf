terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }  
  }
    backend "s3" {
        bucket         = "rushitech-terraform-state-bucket"
        region         = "ap-south-1"
        use_lockfile = true
    }
}