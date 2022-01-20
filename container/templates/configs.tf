
# Variables utilized
 variable "app" {
  description = "Application name which will be running on AWS Fargate"
  default = "python-api-app"
}

 variable "image" {
  description = "image name to spin up the container"
  default = "achidoc/python-flask-api"
}
