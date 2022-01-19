
# Variables utilized
 variable "app" {
  description = "Application name which will be running on AWS Fargate"
  default = "python-api-app"
}

 variable "image" {
  description = "image name to spin up the container"
  default = "python-flask-api:latest"
}

 variable "private_subnets" {
  description = "Number of private subnets"
  default = 2
}

 variable "availability_zones" {
  description = "Number of availability zones"
  default = 1
}

 variable "public_subnets" {
  description = "Number of public subnets"
  default = 2
}