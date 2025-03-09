terraform {
  backend "s3" {
    bucket = "my-bucket-demo21"
    key = "Assignment/terraform.tfstate"
    region = "us-east-1"
  }
}