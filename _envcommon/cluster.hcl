
# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for webserver-cluster. The common variables for each environment to
# deploy webserver-cluster are defined here. This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {

  # Automatically load region-level variables
  #region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  env   = local.environment_vars.locals.environment
  color = local.environment_vars.locals.color
  azs   = local.region_vars.locals.azs

  # Expose the base source URL so different versions of the module can be deployed in different environments.
  base_source_url = "tfr:///terraform-aws-modules/vpc/aws"

  # ---------------------------------------------------------------------------------------------------------------------
  # MODULE PARAMETERS
  # These are the variables we have to pass in to use the module. This defines the parameters that are common across all
  # environments.
  # ---------------------------------------------------------------------------------------------------------------------
  cluster_name = "jbt-terragrunt-${local.env}-${local.color}"
  name         = "jbt-terragrunt-${local.env}-${local.color}"
}

inputs = {
  cluster_name         = "${local.cluster_name}"
  name                 = "${local.name}"
  cidr                 = "10.56.0.0/16"
  azs                  = "${local.azs}"
  private_subnets      = ["10.56.1.0/24", "10.56.2.0/24", "10.56.3.0/24"]
  public_subnets       = ["10.56.4.0/24", "10.56.5.0/24", "10.56.6.0/24"]
  enable_nat_gateway   = true
  create_igw           = true
  enable_dns_hostnames = true

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
}