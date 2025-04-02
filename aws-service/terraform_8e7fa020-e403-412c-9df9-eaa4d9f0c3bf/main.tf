
provider "aws" {
  region = "us-east-1"
}

# IAM Role for SSM with AmazonSSMManagedInstanceCore policy attached
resource "aws_iam_role" "ssm_role_8e7fa020-e403-412c-9df9-eaa4d9f0c3bf" {
  name = "ssm_role_8e7fa020-e403-412c-9df9-eaa4d9f0c3bf"
  assume_role_policy = <<EOF
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
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_role_attach_8e7fa020-e403-412c-9df9-eaa4d9f0c3bf" {
  role       = aws_iam_role.ssm_role_8e7fa020-e403-412c-9df9-eaa4d9f0c3bf.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile_8e7fa020-e403-412c-9df9-eaa4d9f0c3bf" {
  name = "ssm_instance_profile_8e7fa020-e403-412c-9df9-eaa4d9f0c3bf"
  role = aws_iam_role.ssm_role_8e7fa020-e403-412c-9df9-eaa4d9f0c3bf.name
}

# EC2 instance resource with the IAM instance profile attached
resource "aws_instance" "aws_8e7fa020-e403-412c-9df9-eaa4d9f0c3bf" {
  ami           = "ami-0194c744284ae7c15"
  instance_type = "t3.small"
  key_name      = "Aws2"
  vpc_security_group_ids = ["sg-038ccec9310169fce"]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_8e7fa020-e403-412c-9df9-eaa4d9f0c3bf.name
  hibernation = true
  tags = {
    Name = "Aws-8e7fa020-e403-412c-9df9-eaa4d9f0c3bf"
  }
}

output "instance_id" {
  value = aws_instance.aws_8e7fa020-e403-412c-9df9-eaa4d9f0c3bf.id
}
