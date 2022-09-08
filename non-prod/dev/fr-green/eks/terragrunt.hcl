# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that helps keep your code DRY and
# maintainable: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

# We override the terraform block source attribute here just for the dev environment to show how you would deploy a
# different version of the module in a specific environment.
terraform {
  #source = "${include.envcommon.locals.base_source_url}"
  source = "github.com/camptocamp/devops-stack.git//modules/eks/aws"
}


# ---------------------------------------------------------------------------------------------------------------------
# Include configurations that are common used across multiple environments.
# ---------------------------------------------------------------------------------------------------------------------

# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/eks.hcl"
  expose = true
}

dependency "cluster" {
  config_path = "../cluster"
}
# ---------------------------------------------------------------------------------------------------------------------
# We don't need to override any of the common parameters for this environment, so we don't specify any other parameters.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  vpc_id         = dependency.cluster.outputs.vpc_id
  vpc_cidr_block = dependency.cluster.outputs.vpc_cidr_block
  private_subnet_ids = dependency.cluster.outputs.private_subnets
  public_subnet_ids  = dependency.cluster.outputs.public_subnets

}