provider "aws" {
  region = var.region
}

module "network" {
  source = "./vpc"
}

module "compute" {
  source = "./ec2"
  vpc_id = module.network.vpc_id
  subnet_id = module.network.public_subnet_id
}

module "database" {
  source = "./rds"
  vpc_id = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids
}

module "storage" {
  source = "./s3"
}

module "iam" {
  source = "./iam"
}
