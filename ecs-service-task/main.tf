data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["Default VPC"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

resource "aws_security_group" "allow_sg" {
  name        = "kerenp2014_allow_tls"
  description = "Allow traffic"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    #cidr_blocks = [data.aws_vpc.selected.cidr_block]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kerenp2014-ce6"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "kerenp2014-ce6-ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "ecs-tasks.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:ecs:ap-southeast-1:255945442255:*"
          },
          "StringEquals" : {
            "aws:SourceAccount" : "255945442255"
          }
        }
      }
    ]
  })

  tags = local.common_tags
}

# data "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
#   name = "AmazonECSTaskExecutionRolePolicy"
# }

resource "aws_iam_policy" "CustomECSTaskExecutionRolePolicy" {
  name = "CustomECSTaskExecutionRolePolicy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "CustomECSTaskExecutionRolePolicy-attach" {
  name       = "CustomECSTaskExecutionRolePolicy-attachment"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = aws_iam_policy.CustomECSTaskExecutionRolePolicy.arn

}

data "aws_ecs_cluster" "kerenp2014-ce6" {
  cluster_name = "kerenp2014-ce6-ecs-cluster"
}

resource "aws_ecs_task_definition" "kerenp2014-ce6" {
  family                   = "kerenp2014-ce6"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "hello-app"
      image = var.container_image

      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/aws/ecs/kerenp2014-ce6-hello-app"
          awslogs-region        = "ap-southeast-1"
          awslogs-stream-prefix = "kerenp2014-ce6"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "kerenp2014-ce6" {
  name            = "kerenp2014-ce6"
  cluster         = data.aws_ecs_cluster.kerenp2014-ce6.id
  task_definition = aws_ecs_task_definition.kerenp2014-ce6.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = data.aws_subnets.public.ids
    security_groups  = [aws_security_group.allow_sg.id]
    assign_public_ip = true
  }
  #   iam_role        = aws_iam_role.foo.arn
  #   depends_on      = [aws_iam_role_policy.foo]

  #   ordered_placement_strategy {
  #     type  = "binpack"
  #     field = "cpu"
  #   }

  #   load_balancer {
  #     target_group_arn = aws_lb_target_group.foo.arn
  #     container_name   = "mongo"
  #     container_port   = 8080
  #   }

  #   placement_constraints {
  #     type       = "memberOf"
  #     expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  #   }
}