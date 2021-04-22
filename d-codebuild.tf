
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
    image=var.codebuild_image
    # image = "aws/codebuild/standard:1.0"
    environment_variable {
      name="dockerusername"
      value = var.dockerusername
    }
    environment_variable {
      name="dockerpassword"
      value = var.dockerpassword
    }
    environment_variable {
      name="CLUSTER_NAME"
      value = var.cluster-name
    }
    environment_variable{
      name="test_mongo"
      value=var.test_mongo
    }
    environment_variable {
      name="mongoDBip"
      value = var.mongoDBip
    }
    environment_variable {
      name="AWS_ACCESS_KEY_ID"
      value=var.AWS_ACCESS_KEY_ID
    }
    environment_variable {
      name="AWS_SECRET_ACCESS_KEY"
      value=var.AWS_SECRET_ACCESS_KEY
    }
    environment_variable {
      name="configmap"
      value=<<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.project-role.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
    }
    environment_variable {
      name="kubeconfig"
      value=<<e
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.demo.endpoint}
    certificate-authority-data: ${aws_eks_cluster.demo.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster-name}"
e
    }
  }
  
  artifacts{
    type="NO_ARTIFACTS"
  }
  service_role= aws_iam_role.project-role.arn
}