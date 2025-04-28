
provider "aws" {
  region = "us-east-1"
}

# IAM Role for SSM with AmazonSSMManagedInstanceCore policy attached
resource "aws_iam_role" "ssm_role_31c7ad3a-ce49-4bd8-afac-a5de6ce929a9" {
  name = "ssm_role_31c7ad3a-ce49-4bd8-afac-a5de6ce929a9"
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

resource "aws_iam_role_policy_attachment" "ssm_role_attach_31c7ad3a-ce49-4bd8-afac-a5de6ce929a9" {
  role       = aws_iam_role.ssm_role_31c7ad3a-ce49-4bd8-afac-a5de6ce929a9.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile_31c7ad3a-ce49-4bd8-afac-a5de6ce929a9" {
  name = "ssm_instance_profile_31c7ad3a-ce49-4bd8-afac-a5de6ce929a9"
  role = aws_iam_role.ssm_role_31c7ad3a-ce49-4bd8-afac-a5de6ce929a9.name
}

# EC2 instance resource with the IAM instance profile attached
resource "aws_instance" "aws_31c7ad3a-ce49-4bd8-afac-a5de6ce929a9" {
  ami           = "ami-0fb38d50689a99602"
  instance_type = "t3.small"
  key_name      = "Aws2"
  vpc_security_group_ids = ["sg-038ccec9310169fce"]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_31c7ad3a-ce49-4bd8-afac-a5de6ce929a9.name
  hibernation = true
  tags = {
    Name = "aa-31c7ad3a-ce49-4bd8-afac-a5de6ce929a9"
  }
}

output "instance_id" {
  value = aws_instance.aws_31c7ad3a-ce49-4bd8-afac-a5de6ce929a9.id
}
