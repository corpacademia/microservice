
provider "aws" {
  region = "us-east-1"
}

# IAM Role for SSM with AmazonSSMManagedInstanceCore policy attached
resource "aws_iam_role" "ssm_role_40a8a8bd-1f89-4ada-bcfe-aa51dfdaf58a" {
  name = "ssm_role_40a8a8bd-1f89-4ada-bcfe-aa51dfdaf58a"
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

resource "aws_iam_role_policy_attachment" "ssm_role_attach_40a8a8bd-1f89-4ada-bcfe-aa51dfdaf58a" {
  role       = aws_iam_role.ssm_role_40a8a8bd-1f89-4ada-bcfe-aa51dfdaf58a.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile_40a8a8bd-1f89-4ada-bcfe-aa51dfdaf58a" {
  name = "ssm_instance_profile_40a8a8bd-1f89-4ada-bcfe-aa51dfdaf58a"
  role = aws_iam_role.ssm_role_40a8a8bd-1f89-4ada-bcfe-aa51dfdaf58a.name
}

# EC2 instance resource with the IAM instance profile attached
resource "aws_instance" "aws_40a8a8bd-1f89-4ada-bcfe-aa51dfdaf58a" {
  ami           = "ami-06ab74a6eb9ec9759"
  instance_type = "t3.small"
  key_name      = "Aws2"
  vpc_security_group_ids = ["sg-038ccec9310169fce"]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_40a8a8bd-1f89-4ada-bcfe-aa51dfdaf58a.name
  hibernation = true
  tags = {
    Name = "aaa-40a8a8bd-1f89-4ada-bcfe-aa51dfdaf58a"
  }
}

output "instance_id" {
  value = aws_instance.aws_40a8a8bd-1f89-4ada-bcfe-aa51dfdaf58a.id
}
