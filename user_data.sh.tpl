#!/bin/bash

cat >>/etc/ecs/ecs.config <<EOF
ECS_CLUSTER=${cluster_name}
EOF

service docker restart
