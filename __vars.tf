variable "cluster_id" {
  type     = string
  nullable = true
}

variable "name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "task_cpu" {
  type = number
}

variable "task_memory" {
  type = number
}

variable "region" {
  type = string
}

variable "port_mappings" {
  type = list(number)
}

variable "environment" {
  type = list(map(string))
}

variable "container_image" {
  type = string
}

variable "task_count" {
  type = number
}

variable "security_groups" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "assign_public_ip" {
  type = bool
}

variable "role_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}
