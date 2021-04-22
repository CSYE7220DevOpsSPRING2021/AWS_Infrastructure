#
# EKS Cluster Resources
#  * EKS Cluster
#
#  It can take a few minutes to provision on AWS

# Note: replace subnet_ids = ["${aws_subnet.demo.*.id}"]
# with:
# subnet_ids = flatten([aws_subnet.demo.0.id, aws_subnet.demo.1.id])
# or:
# subnet_ids = "${aws_subnet.demo.*.id}"

resource "aws_eks_cluster" "demo" {
  name     = var.cluster-name
  role_arn = aws_iam_role.project-role.arn
  enabled_cluster_log_types = [ "api","audit","authenticator","controllerManager","scheduler" ]
  vpc_config {
    security_group_ids = [aws_security_group.demo-cluster.id]
    #subnet_ids         = "${aws_subnet.demo.*.id}"
    subnet_ids         = aws_subnet.demo.*.id
  }

  depends_on = [
    aws_iam_role_policy_attachment.project-role-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.project-role-AmazonEKSServicePolicy,
  ]
}
