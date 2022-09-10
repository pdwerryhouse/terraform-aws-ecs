

module "ecs_with_alb" {
  source = "../.."

  name = "terraform-test"
  env = "dev"
  desired_capacity = 1
  instance_type = "t3a.small"
  max_size = 3
  min_size = 0
  ssh_key_name = "aws"
  subnets = [ "subnet-094951b0b882e2fe6", "subnet-09750086bac6e9a0c"]
  volume_type = "gp2"
  volume_size = "40"
  vpc_id = "vpc-0dbafb9961957de28"

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
