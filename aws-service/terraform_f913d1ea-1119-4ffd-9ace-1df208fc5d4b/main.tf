
provider "aws" {
  region = "us-east-1"
}

# IAM Role for SSM with AmazonSSMManagedInstanceCore policy attached
resource "aws_iam_role" "ssm_role_f913d1ea-1119-4ffd-9ace-1df208fc5d4b" {
  name = "ssm_role_f913d1ea-1119-4ffd-9ace-1df208fc5d4b"
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

resource "aws_iam_role_policy_attachment" "ssm_role_attach_f913d1ea-1119-4ffd-9ace-1df208fc5d4b" {
  role       = aws_iam_role.ssm_role_f913d1ea-1119-4ffd-9ace-1df208fc5d4b.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile_f913d1ea-1119-4ffd-9ace-1df208fc5d4b" {
  name = "ssm_instance_profile_f913d1ea-1119-4ffd-9ace-1df208fc5d4b"
  role = aws_iam_role.ssm_role_f913d1ea-1119-4ffd-9ace-1df208fc5d4b.name
}

# EC2 instance resource with the IAM instance profile attached
resource "aws_instance" "aws_f913d1ea-1119-4ffd-9ace-1df208fc5d4b" {
  ami           = "ami-0b2cfe305c3b7c306"
  instance_type = "t3.small"
  key_name      = "Aws2"
  vpc_security_group_ids = ["sg-038ccec9310169fce"]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_f913d1ea-1119-4ffd-9ace-1df208fc5d4b.name
  hibernation = true
  tags = {
    Name = "aa-f913d1ea-1119-4ffd-9ace-1df208fc5d4b"
  }
}

output "instance_id" {
  value = aws_instance.aws_f913d1ea-1119-4ffd-9ace-1df208fc5d4b.id
}
