#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#

resource "aws_iam_role_policy_attachment" "project-role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.project-role.name
}

resource "aws_iam_role_policy_attachment" "project-role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.project-role.name
}

resource "aws_iam_role_policy_attachment" "project-role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.project-role.name
}

resource "aws_iam_instance_profile" "project-role" {
  name = "terraform-eks-demo"
  role = aws_iam_role.project-role.name
}