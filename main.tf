provider "aws" {
  region    = "us-east-1" #var.aws_region
  access_key = "AKIAVQSD4QIGUH5T5IHL"
  secreate_key = "k9g6grCK2F68S45ABzRVJwxgXeSLqXhIclRk1iut"
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
  source           = modules\\eks
  cluster_name     = var.cluster_name
#  cluster_version = "1.14"
  subnet_ids       = var.private_subnet_ids #module.vpc.private_subnet_ids
  vpc_id           = var.vpc_id #module.vpc.vpc_id
  ami_type         = var.ami_type
  worker_name      = var.worker_name
  desired_size     = var.desired_size
  min_size         = var.min_size
  instance_types   = var.instance_types
}