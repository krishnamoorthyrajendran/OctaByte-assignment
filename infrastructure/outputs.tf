output "vpc_id" {
  value = module.vpc.vpc_id
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "eks_cluster" {
  value = module.eks.cluster_name
}
