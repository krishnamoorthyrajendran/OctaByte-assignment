terraform {
  backend "s3" {
    bucket         = "myapp-terraform-state-8byte"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
