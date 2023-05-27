
resource "aws_key_pair" "deployer" {
  key_name   = "aws"
  public_key = var.ssh_public_key
}

data "aws_vpc" "vpc" {
  default = true
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

module "ecs_with_alb" {
  source = "../.."

  name = "terraform-test"
  env = "dev"
  desired_capacity = 1
  instance_type = "t3a.small"
  max_size = 3
  min_size = 0
  ssh_key_name = "aws"
  subnets = [ data.aws_subnets.subnets.ids[0], data.aws_subnets.subnets.ids[1] ]
  volume_type = "gp2"
  volume_size = "40"
  vpc_id = data.aws_vpc.vpc.id

  container_definitions = jsonencode([
    {
      name = "nginx"
      image = "nginxdemos/hello"
      cpu = 10
      memory = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort = 80
        }
      ]
    }
  ])

}
