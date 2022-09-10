
resource "aws_ecs_task_definition" "ecs-service-taskdef" {
  family        = "${var.name}-${var.env}-ecs-cluster"
  network_mode  = "bridge"
  
  container_definitions = var.container_definitions
}

resource "aws_ecs_service" "ecs-service" {
  name            = "${var.name}-${var.env}-ecs-service"
  cluster         = aws_ecs_cluster.cluster.arn
  task_definition = aws_ecs_task_definition.ecs-service-taskdef.arn
  desired_count   = var.desired_capacity
}
