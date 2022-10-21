locals {
  user_data_ecs = <<EODATA

cat >>/etc/ecs/ecs.config <<EOF
ECS_CLUSTER="${var.name}-${var.env}-ecs-cluster"
EOF

service docker restart
EODATA

  user_data = join("\n", ["#!/bin/bash", var.user_data, local.user_data_ecs])
}
