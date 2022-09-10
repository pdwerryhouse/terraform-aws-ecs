
# ECS with ALB

This example creates an ALB, a launch template, an autoscaling group, and
an ECS cluster using Amazon Linux 2, and deploys the nginxdemos/hello docker
image into them

## Parameters

| Parameter        | Description                             |
|------------------|-----------------------------------------|
| env              | Environment name ('dev', 'prod', etc)   |
| desired_capacity | Desired number of instances             |
| instance_type    | EC2 instance types                      |
| max_size         | Max size of autoscaling group           |
| min_size         | Min size of autoscaling group           |
| name             | Name of instances                       |
| subnets          | List of subnet IDs                      |
| volume_type      | EBS volume type                         |
| volume_size      | Size of root EBS volume in Gb           |
| vpc_id           | VPC ID                                  |

## Example

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

