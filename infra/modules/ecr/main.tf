resource "aws_ecr_repository" "repo" {
  for_each = toset(var.repo_names)

  name                 = "${var.name_prefix}-${each.key}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${each.key}"
  })
}
