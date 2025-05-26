
provider "aws" {
  region = "us-east-1"
}

# IAM Role for SSM with AmazonSSMManagedInstanceCore policy attached
resource "aws_iam_role" "ssm_role_6e7a7960-e8a4-4f4c-84c9-7b49e38b62d0" {
  name = "ssm_role_6e7a7960-e8a4-4f4c-84c9-7b49e38b62d0"
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

resource "aws_iam_role_policy_attachment" "ssm_role_attach_6e7a7960-e8a4-4f4c-84c9-7b49e38b62d0" {
  role       = aws_iam_role.ssm_role_6e7a7960-e8a4-4f4c-84c9-7b49e38b62d0.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile_6e7a7960-e8a4-4f4c-84c9-7b49e38b62d0" {
  name = "ssm_instance_profile_6e7a7960-e8a4-4f4c-84c9-7b49e38b62d0"
  role = aws_iam_role.ssm_role_6e7a7960-e8a4-4f4c-84c9-7b49e38b62d0.name
}

# EC2 instance resource with the IAM instance profile attached
resource "aws_instance" "aws_6e7a7960-e8a4-4f4c-84c9-7b49e38b62d0" {
  ami           = "ami-090a624d5b9b3792c"
  instance_type = "t3.small"
  key_name      = "Aws2"
  vpc_security_group_ids = ["sg-038ccec9310169fce"]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_6e7a7960-e8a4-4f4c-84c9-7b49e38b62d0.name
  hibernation = true
  tags = {
    Name = "single-vm-6e7a7960-e8a4-4f4c-84c9-7b49e38b62d0"
  }
}

output "instance_id" {
  value = aws_instance.aws_6e7a7960-e8a4-4f4c-84c9-7b49e38b62d0.id
}
