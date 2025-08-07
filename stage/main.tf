provider "aws" {
  region = local.aws_region
}

module "webserver" {
  source         = "../modules/webserver"
  webserver_name = "${local.environment}-webserver"
  min_size       = 1
  max_size       = 1
}

module "database" {
  source = "../modules/database"
  environment = local.environment
}
