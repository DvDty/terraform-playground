terraform {
  backend "s3" {
    region       = "eu-central-1"
    key          = "stage/terraform.tfstate"
    bucket       = "terraform-state-93fh8a023"
    encrypt      = true
    use_lockfile = true
  }
}
