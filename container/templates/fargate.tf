##################################################
# AWS Fargate
##################################################
resource "aws_ecs_cluster" "api_ecs_cluster" {
  name = "${var.app}-ECSCluster"

  tags = {
    Name = "${var.app}-ecs-fargate-cluster"
  }
}

resource "aws_ecs_task_definition" "api_ecs_task_definition" {
  family                   = "${var.app}-ECSTaskDefinition"
  task_role_arn            = "${aws_iam_role.api_ecs_task_role.arn}"
  execution_role_arn       = "${aws_iam_role.api_ecs_task_execution_role.arn}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  container_definitions = jsonencode([
    {
      name      = "${var.app}"
      image     = "${var.image}"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
}

resource "aws_vpc" "api-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_lb_target_group" "api-lb-target-group" {
  name        = "${var.app}-lb-target-group"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${aws_vpc.api-vpc.id}"
}

resource "aws_ecs_service" "api_ecs_service" {
  name            = "${var.app}-ECSService"
  cluster         = "${aws_ecs_cluster.api_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.api_ecs_task_definition.arn}"
  desired_count   = 2

  load_balancer {
    target_group_arn = "${aws_lb_target_group.api-lb-target-group.arn}"
    container_name   = "${var.app}"
    container_port   = 8080
  }

}