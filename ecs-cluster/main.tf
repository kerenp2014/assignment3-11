# data "aws_vpc" "selected" {
#   filter {
#     name   = "tag:Name"
#     values = ["Default VPC"]
#   }
# }

# data "aws_subnets" "public" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.selected.id]
#   }
# }

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "kerenp2014-ce6-ecs-cluster" #Change

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }
}

resource "aws_ecrpublic_repository" "hello-app" {
  provider = aws.us_east_1

  repository_name = "kerenp2014-ce6/hello-app"

  catalog_data {
    about_text        = "This repository is for testing with ECS"
    architectures     = ["x86-64"]
    description       = "This repository is for testing with ECS"
    # logo_image_blob   = filebase64(image.png)
    operating_systems = ["Linux"]
    usage_text        = "Just Use ME!!"
  }

  tags = merge(local.common_tags, {
    env = "Testing ECR/ECS"
  })
}
