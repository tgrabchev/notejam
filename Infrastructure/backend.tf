#Backend tfstate uploaded to S3 bucket
# terraform {
#   backend "s3" {
#     bucket = "my-tf-state-bucket-notejam"
#     key    = "global/terraform.state"
#     region = "eu-west-2"
#   }
# }