locals {
  user_data_ecs = <<EODATA

yum -y install awscli

export AWS_DEFAULT_REGION=us-east-1

cat >>/etc/ecs/ecs.config <<EOF

ECS_CLUSTER=${var.name}-${var.env}-ecs-cluster
ECS_ENGINE_AUTH_TYPE=docker
EOF

service docker restart
EODATA

  user_data = join("\n", ["#!/bin/bash", var.user_data, local.user_data_ecs])
}
