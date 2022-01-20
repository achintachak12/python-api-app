##################################################
# AWS ECR
##################################################

resource "aws_ecr_repository" "api_ecs_ecr_repo" {
  name = "python-flask-api-repo"
}