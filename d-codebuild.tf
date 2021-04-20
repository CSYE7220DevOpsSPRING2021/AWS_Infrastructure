
data "aws_caller_identity" "current" {}
resource "aws_codebuild_project" "uber_be_codebuild_project" {
  name= "uber-be"
  description = "uber be flask api server"
  source {
    type= "GITHUB"
    location= "https://github.com/CSYE7220DevOpsSPRING2021/backEnd.git"
    git_clone_depth = 1
    git_submodules_config {
      fetch_submodules = true
    }
  }
  source_version = "master"
  environment {
    image_pull_credentials_type = "SERVICE_ROLE"
    privileged_mode = true
    compute_type="BUILD_GENERAL1_SMALL"
    type="LINUX_CONTAINER"
    # image=var.codebuild_image
    image = "aws/codebuild/standard:1.0"
    environment_variable{
      name="test_mongo"
      value=var.test_mongo
    }
    environment_variable {
      name="mongoDBip"
      value = var.mongoDBip
    }
  }
  
  artifacts{
    type="NO_ARTIFACTS"
  }
  service_role= aws_iam_role.project-role.arn
}