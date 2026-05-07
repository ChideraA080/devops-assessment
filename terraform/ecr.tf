resource "aws_ecr_repository" "app_repo" {
  name         = "devops-app-repo"
  force_delete = true
}