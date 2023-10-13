# Optional - Only necessary if you want a full Ampclify App running in AWS (not just localhost)

resource "aws_codecommit_repository" "mpc_codecommit_repo" {
  count           = var.mpc_create_codecommit_repo ? 1 : 0
  repository_name = var.mpc_codecommit_repo_name
  description     = var.mpc_codecommit_repo_description
  default_branch  = var.mpc_codecommit_repo_default_branch

  tags = merge(
    {
      "AppName" = var.mpc_app_name
    },
    var.tags,
  )
}
