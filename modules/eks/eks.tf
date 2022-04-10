resource "aws_iam_role" "${var.cluster_name}" {
  name =  "${var.cluster_name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "${var.cluster_name}-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.${var.cluster_name}.name
}

resource "aws_iam_role_policy_attachment" "${var.cluster_name}-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.${var.cluster_name}.name
}

resource "aws_security_group" "${var.cluster_name}-sg" {
  name        = "terraform-eks-${var.cluster_name}"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-${var.cluster_name}"
  }
}

resource "aws_security_group_rule" "${var.cluster_name}-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.${var.cluster_name}.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "${var.cluster_name}" {
  name     = "${var.cluster-name}"
  role_arn = aws_iam_role.${var.cluster_name}.arn

  vpc_config {
    security_group_ids = [aws_security_group.${var.cluster_name}.id]
    subnet_ids         = var.subnet_ids   #aws_subnet.${var.cluster_name}[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.${var.cluster_name}-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.${var.cluster_name}-AmazonEKSVPCResourceController,
	
  ]
}