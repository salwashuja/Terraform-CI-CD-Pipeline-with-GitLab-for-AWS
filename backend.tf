terraform {
  backend "s3" {
    bucket = "statefile-bucket"
    key    = "statefile"
    region = "us-east-1"
    dynamodb_table = "terraform_state_lock_table"
  }
}
