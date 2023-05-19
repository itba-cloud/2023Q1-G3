output "vpc_cidr" {
    description = "VPC CIDR block"
    value = module.vpc.vpc_cidr_block
}

output "private_subnets_ids" {
  description = "List of IDs of private subnets"
  value = module.vpc.private_subnets
}

output "vpc_id" {
  description = "VPC id"
  value       = module.vpc.vpc_id 
}