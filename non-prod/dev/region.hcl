# Set common variables for the region. This is automatically pulled in in the root terragrunt.hcl configuration to
# configure the remote state bucket and pass forward to the child modules as inputs.
locals {
  aws_region = "eu-west-1"
  azs        = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  cluster_issuer = "letsencrypt-staging"
}