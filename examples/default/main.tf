

module "ecs_with_alb" {
  source = "../.."

  name = "terraform-test"
  env = "dev"
  desired_capacity = 1
  instance_type = "t3a.small"
  max_size = 3
  min_size = 0
  ssh_key_name = "aws"
  subnets = [ "subnet-0d67f4d93f5e27883", "subnet-0ca61965a1d6c9ac5" ]
  volume_type = "gp2"
  volume_size = "40"
  vpc_id = "vpc-0c4af4912f33a62b1"

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
