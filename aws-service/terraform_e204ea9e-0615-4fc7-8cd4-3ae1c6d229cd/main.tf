
provider "aws" {
  region = "us-east-1"
}

# IAM Role for SSM with AmazonSSMManagedInstanceCore policy attached
resource "aws_iam_role" "ssm_role_e204ea9e-0615-4fc7-8cd4-3ae1c6d229cd" {
  name = "ssm_role_e204ea9e-0615-4fc7-8cd4-3ae1c6d229cd"
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

resource "aws_iam_role_policy_attachment" "ssm_role_attach_e204ea9e-0615-4fc7-8cd4-3ae1c6d229cd" {
  role       = aws_iam_role.ssm_role_e204ea9e-0615-4fc7-8cd4-3ae1c6d229cd.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile_e204ea9e-0615-4fc7-8cd4-3ae1c6d229cd" {
  name = "ssm_instance_profile_e204ea9e-0615-4fc7-8cd4-3ae1c6d229cd"
  role = aws_iam_role.ssm_role_e204ea9e-0615-4fc7-8cd4-3ae1c6d229cd.name
}

# EC2 instance resource with the IAM instance profile attached
resource "aws_instance" "aws_e204ea9e-0615-4fc7-8cd4-3ae1c6d229cd" {
  ami           = "ami-0475fc1bab1e86604"
  instance_type = "t3.small"
  key_name      = "Aws2"
  vpc_security_group_ids = ["sg-038ccec9310169fce"]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_e204ea9e-0615-4fc7-8cd4-3ae1c6d229cd.name
  hibernation = true
  tags = {
    Name = "aa-e204ea9e-0615-4fc7-8cd4-3ae1c6d229cd"
  }
}

output "instance_id" {
  value = aws_instance.aws_e204ea9e-0615-4fc7-8cd4-3ae1c6d229cd.id
}
