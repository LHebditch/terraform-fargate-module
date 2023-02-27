# aws_ecs_task_definition
output "task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}

output "task_definition_revision" {
  value = aws_ecs_task_definition.this.revision
}

# aws_ecs_cluster
output "cluster_arn" {
  value = element(concat(aws_ecs_cluster.this.*.arn, [""]), 0)
}

output "cluster_id" {
  value = element(concat(aws_ecs_cluster.this.*.id, [""]), 0)
}

# aws_ecs_service
output "service_arn" {
  value = aws_ecs_service.this.id
}

output "service_name" {
  value = aws_ecs_service.this.name
}
