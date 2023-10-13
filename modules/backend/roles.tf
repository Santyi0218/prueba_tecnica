##ROL FARGATE
resource "aws_iam_role" "fargate_execution_role" {
  name = "FargateExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

##POLITICA
resource "aws_iam_policy" "fargate_policy" {
  name        = "FargatePolicy"
  description = "Política para Fargate con acceso a RDS, EFS y Systems Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "rds:DescribeDBClusters",
          "rds:DescribeDBInstances",
          "rds:Connect"
        ],
        Effect   = "Allow",
        Resource = aws_db_instance.rds_mysql.arn
      },
      {
        Action   = ["elasticfilesystem:DescribeFileSystems"],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "ssm:DescribeInstanceInformation",
          "ssm:GetCommandInvocation",
          "ssm:ListCommands",
          "ssm:ListCommandInvocations",
          "ssm:ListDocuments"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

##ATTACH POLITICA A ROL
resource "aws_iam_role_policy_attachment" "fargate_policy_attachment" {
  policy_arn = aws_iam_policy.fargate_policy.arn
  role       = aws_iam_role.fargate_execution_role.name
}