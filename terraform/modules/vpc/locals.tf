locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.vpc_az_count)
}