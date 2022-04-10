provider "aws" {
  region    = "us-east-1" #var.aws_region
}
/*
terraform {
  backend "s3" {
    bucket  = "telioev-store"
    key     = "telioev/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = "true"
  }
}
*/

module "eks" {
  source           = modules/eks
  cluster_name     = var.cluster_name
#  cluster_version = "1.14"
  subnet_ids       = var.private_subnet_ids #module.vpc.private_subnet_ids
  vpc_id           = var.vpc_id #module.vpc.vpc_id
  ami_type         = var.ami_type
  worker_name      = var.worker_name
  desired_size     = var.desired_size
  min_size         = var.min_size
  instance_types   = var.instance_types
  vpc_id           = "vpc-08cdadb2b5fe29575"
}