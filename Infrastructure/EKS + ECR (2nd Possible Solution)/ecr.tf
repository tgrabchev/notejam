provider "aws" {
  region = "eu-west-2"

}

resource "aws_ecr_repository" "my-ecr" {
  name                 = "docker_ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}