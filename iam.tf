
resource "aws_iam_role" "cluster-ecs-role" {
  name = "${var.name}-${var.env}-ecs-role"
  force_detach_policies = true
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
   role = aws_iam_role.cluster-ecs-role.name
   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "cluster-ecs-profile" {
  name = "${var.name}-${var.env}-ecs-profile"
  role = aws_iam_role.cluster-ecs-role.name
}

resource "aws_iam_role_policy" "cluster-ecs-policy" {
  name = "${var.name}-${var.env}-ecs-policy"
  role = aws_iam_role.cluster-ecs-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:Encrypt"
      ],
      "Resource": "*"
    }
  ]
}
EOF

}
