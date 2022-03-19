variable "aws_ami" {
  description = "The instances AMI in the London region"
  default     = "ami-03e88be9ecff64781"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"

}

variable "web-subnet-1" {
  description = "The CIDR Block for the web-subnet-1 subnet"
  default = "10.0.1.0/24" 
}

variable "web-subnet-2" {
  description = "The CIDR Block for the web-subnet-2 subnet"
  default = "10.0.2.0/24" 
}

variable "vpc-cidr" {
  description = "The CIDR Block for the VPC"
  default = "10.0.0.0/16" 
}

variable "availability-zone-a" {
  description = "Availability Zone A"
  default = "eu-west-2a" 
}

variable "availability-zone-b" {
  description = "Availability Zone B"
  default = "eu-west-2b" 
}

variable "database-subnet-1" {
  description = "The CIDR Block for the database-subnet-1 private subnet"
  default = "10.0.21.0/24" 
}

variable "database-subnet-2" {
  description = "The CIDR Block for the database-subnet-2 private subnet"
  default = "10.0.22.0/24" 
}
