module "vpc" {
  source = "./modules/vpc"

  region       = "ap-south-1"
  project_name = "myapp"

  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

  azs = ["ap-south-1a", "ap-south-1b"]
}

module "rds" {
  source = "./modules/rds"

  project_name = "myapp"

  db_name     = "appdb"
  db_username = "postgres"
  db_password = "postgres"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  allowed_cidr_blocks = ["10.0.0.0/16"]
}

