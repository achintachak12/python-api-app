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
  container_definitions = <<DEFINITION
    [
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
  ]
  DEFINITION
}

resource "aws_ecs_service" "api-ecs-service" {
  name                 = "${var.app}-ecs-service"
  cluster              = aws_ecs_cluster.api-ecs-cluster.id
  task_definition      = aws_ecs_task_definition.api_ecs_task_definition.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = aws_subnet.api-private.*.id
    assign_public_ip = false
    security_groups = [
      aws_security_group.service_security_group.id,
      aws_security_group.load_balancer_security_group.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api-target-group.arn
    container_name   = "python-flask-api"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.listener]
}

resource "aws_alb" "api-alb" {
  name               = "${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.api-public.*.id
  security_groups    = [aws_security_group.load_balancer_security_group.id]
}

resource "aws_lb_target_group" "api-target-group" {
  name        = "${var.app}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.api_vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "api-listener" {
  load_balancer_arn = aws_alb.api-alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api-target-group.id
  }
}