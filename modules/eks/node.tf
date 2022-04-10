resource "aws_iam_role" "${var.worker_name}" {
  name = "terraform-eks-${var.worker_name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "${var.worker_name}-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.${var.worker_name}.name
}

resource "aws_iam_role_policy_attachment" "${var.worker_name}-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.${var.worker_name}.name
}

resource "aws_iam_role_policy_attachment" "${var.worker_name}-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.${var.worker_name}.name
}

resource "aws_eks_node_group" "${var.worker_name}" {
  cluster_name    = aws_eks_cluster.${var.worker_name}.name
  node_group_name = "${var.worker_name}"
  node_role_arn   = aws_iam_role.${var.worker_name}.arn
  subnet_ids      = aws_subnet.${var.worker_name}[*].id
  ami_type        = var.ami_type
  instance_types  = var.instance_types

  scaling_config {
    desired_size = "${var.desired_size}"
    max_size     = "${var.max_size}"
    min_size     = "${var.min_size}"
  }

  depends_on = [
    aws_iam_role_policy_attachment.${var.worker_name}-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.${var.worker_name}-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.${var.worker_name}-AmazonEC2ContainerRegistryReadOnly,
	aws_eks_cluster.${var.cluster_name}
  ]
}