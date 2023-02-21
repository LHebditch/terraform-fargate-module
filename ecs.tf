locals {
  formatted_port_mappings = [for port in var.port_mappings : {
    hostPort : port,
    protocol : "tcp",
    containerPort : port
  }]
}

resource "aws_ecs_cluster" "this" {
  // we only want to create this if the user doesn't give us a cluster to use
  count = var.cluster_id == null ? 0 : 1

  name = "TF-${var.name}-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = var.tags
}

resource "aws_ecs_task_definition" "this" {
  family                   = "TF-${var.name}-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc" // required for use with fargate
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  container_definitions = <<DEFINITION
  [
    {
        "dnsSearchDomain": null,
        "environmentFiles": null,
        "logConfiguration": {
            "logDriver": "awslogs",
            "secretOptions": null,
            "options": {
                "awslogs-group": "/ecs/${var.name}",
                "awslogs-region": "${var.region}",
                "awslogs-stream-prefix": "ecs"
            }
        },
        "entryPoint": [],
        "portMappings": ${jsonencode(local.formatted_port_mappings)},
        "command": [],
        "linuxParameters": null,
        "cpu": 0,
        "environment": ${jsonencode(var.environment)},
        "resourceRequirements": null,
        "ulimits": null,
        "dnsService": null,
        "mountPoints": [],
        "workingDirectory": null,
        "secrets": null,
        "dockerSecurityOptions": null,
        "memory": null,
        "memoryReservation": null,
        "volumesFrom": [],
        "stopTimeout": null,
        "image": "${var.container_image}",
        "startTimeout": null,
        "firelensConfiguration": null,
        "dependsOn": null,
        "disableNetworking": null,
        "interactive": null,
        "healthCheck": null,
        "essential": true,
        "links": [],
        "hostname": null,
        "extraHosts": null,
        "pseudoTerminal": null,
        "user": null,
        "readonlyFileSystem": null,
        "dockerLabels": null,
        "systemControls": null,
        "privileged": null,
        "name": "custom"
    }
  ]
  DEFINITION

  tags = var.tags
}

resource "aws_ecs_service" "this" {
  name            = "TF-${var.name}-service"
  cluster         = var.cluster_id == null ? var.cluster_id : aws_ecs_cluster.this[0].id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.task_count

  network_configuration {
    security_groups  = var.security_groups
    subnets          = var.subnets
    assign_public_ip = var.assign_public_ip
  }
  tags                    = var.tags
  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"
}
