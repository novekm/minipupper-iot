resource "aws_ecr_repository" "mpc_ecr_repo" {
  name = "robomaker"
  # image_tag_mutability = "MUTABLE"

  # image_scanning_configuration {
  #   scan_on_push = true
  # }
}
