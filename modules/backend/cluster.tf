resource "aws_ecs_cluster" "cluster" {
  name = "Cluster_${var.name}"
}

resource "aws_ecs_cluster_capacity_providers" "ecs_fargate" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}