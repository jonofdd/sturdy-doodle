terraform {
  backend "s3" {
    bucket         = "ihurezanu-alabs"
    key            = "terraform_states/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}