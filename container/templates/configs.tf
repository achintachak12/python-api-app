
# Variables utilized
 variable "app" {
  description = "Application name which will be running on AWS Fargate"
  default = "python-api-app"
}

 variable "image" {
  description = "image name to spin up the container"
  default = "achidoc/python-flask-api"
}

 variable "private_subnets" {
  description = "Private Subnets"
  default = ["10.10.0.0/24", "10.10.1.0/24"]
}

 variable "availability_zones" {
  description = "Availability Zones"
  default = ["us-east-1a", "us-east-1b"]
}

 variable "public_subnets" {
  description = "Number of public subnets"
  default = ["10.10.100.0/24", "10.10.101.0/24"]
}