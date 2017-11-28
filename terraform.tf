variable "aws_region" {
  default = "eu-central-1"
}

variable "service_name" {
  default = "shepherd"
}

variable "group" {
  default = "tools"
}

data "terraform_remote_state" "core" {
  backend = "s3"
  config {
    bucket = "seed.infrastructure"
    key    = "dev/terraform.tfstate"
    region = "eu-central-1"
  }
}

terraform {
  backend "s3" {
    bucket = "seed.infrastructure"
    key    = "services/shepherd.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  version = "~> 1.2"
  shared_credentials_file = "~/.aws/credentials"
  region = "${var.aws_region}"
}

module "base" {
  source = "git::ssh://git@gitlab.seeds.stepstone.com./infrastructure/core.git//ecs_service/ecs_service_base"
  name = "${var.service_name}"
  group = "${var.group}"
}

module "production" {
  source = "git::ssh://git@gitlab.seeds.stepstone.com./infrastructure/core.git//ecs_service/ecs_service_instance"
  cluster = "tools"

  name = "${var.service_name}"
  group = "${var.group}"
  subnets = "${data.terraform_remote_state.core.private_subnets_ids}"
  service_role = "${data.terraform_remote_state.core.ecs_service_role}"
  vpc_id = "${data.terraform_remote_state.core.vpc_id}"
  zone_id = "${data.terraform_remote_state.core.main_zone_id}"
  base_domain = "${data.terraform_remote_state.core.base_domain}"
  traffic_security_group = "${data.terraform_remote_state.core.elb_internal_ips_group_id}"
  repository_url = "${module.base.repository_url}"
  use_consul_service_discovery = false
}
