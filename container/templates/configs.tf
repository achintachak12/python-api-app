# Variables utilized
 variable "app" {
  description = "Application name which will be running on AWS Fargate"
  default = "python-api-app"
}

 variable "image" {
  description = "image name to spin up the container"
  default = "achidoc/python-flask-api"
}

 variable "availability_zones" {
  description = "Availability Zones"
  default = ["us-east-1a", "us-east-1b"]
}

variable "availability_primary_zone" {
  description = "Availability Primary Zone"
  default = "us-east-1a"
}

 variable "public_subnets" {
  description = "Number of public subnets"
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}
