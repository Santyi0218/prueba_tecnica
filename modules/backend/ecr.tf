##ECR IMAGEN WORDPRESS
resource "aws_ecr_repository" "wordpress" {
  name                 = "wordpress_${var.name}"
  image_tag_mutability = "MUTABLE" ##TAGS REEMPLAZABLES

  image_scanning_configuration {
    scan_on_push = false
  }
}