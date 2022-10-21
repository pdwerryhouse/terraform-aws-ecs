
resource "aws_security_group" "sg" {
  name        = "${var.name}-${var.env}-ecs-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.name}-${var.env}-ecs-cluster"
}

resource "aws_launch_template" "ecs-launch-template" {
  image_id                  = data.aws_ami.latest_ecs_ami.image_id
  instance_type             = var.instance_type
  key_name                  = var.ssh_key_name
  ebs_optimized             = true
  update_default_version    = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      volume_type           = var.volume_type
      volume_size           = var.volume_size
    }
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.cluster-ecs-profile.arn
  }

  vpc_security_group_ids = [ aws_security_group.sg.id ]

  user_data = base64encode(local.user_data)
}

resource "aws_autoscaling_group" "cluster" {
  name_prefix = "${var.name}-${var.env}-asg-"
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity
  target_group_arns = [ aws_lb_target_group.tg.id ] 
  vpc_zone_identifier = var.subnets

  launch_template {
    id = aws_launch_template.ecs-launch-template.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                   = "Name"
    value                 = "${var.name}-${var.env}-ecs-node"
    propagate_at_launch   = true
  }
}
