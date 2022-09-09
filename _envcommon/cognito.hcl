locals {

  # Automatically load region-level variables
  #region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env   = local.environment_vars.locals.environment
  color = local.environment_vars.locals.color

  # Expose the base source URL so different versions of the module can be deployed in different environments.
  base_source_url = "../../../../../modules//cognito"

  # ---------------------------------------------------------------------------------------------------------------------
  # MODULE PARAMETERS
  # These are the variables we have to pass in to use the module. This defines the parameters that are common across all
  # environments.
  # ---------------------------------------------------------------------------------------------------------------------
  cluster_name = "jbt-${local.env}-${local.color}"
}

# dependency "cluster" {
#   config_path = "../cluster"
# }

inputs = {

  cluster_name = local.cluster_name
  
}
