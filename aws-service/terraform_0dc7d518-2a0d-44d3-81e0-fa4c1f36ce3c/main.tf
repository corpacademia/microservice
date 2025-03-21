
provider "aws" {
  region = "us-east-1"
}

# IAM Role for SSM with AmazonSSMManagedInstanceCore policy attached
resource "aws_iam_role" "ssm_role_0dc7d518-2a0d-44d3-81e0-fa4c1f36ce3c" {
  name = "ssm_role_0dc7d518-2a0d-44d3-81e0-fa4c1f36ce3c"
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

resource "aws_iam_role_policy_attachment" "ssm_role_attach_0dc7d518-2a0d-44d3-81e0-fa4c1f36ce3c" {
  role       = aws_iam_role.ssm_role_0dc7d518-2a0d-44d3-81e0-fa4c1f36ce3c.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile_0dc7d518-2a0d-44d3-81e0-fa4c1f36ce3c" {
  name = "ssm_instance_profile_0dc7d518-2a0d-44d3-81e0-fa4c1f36ce3c"
  role = aws_iam_role.ssm_role_0dc7d518-2a0d-44d3-81e0-fa4c1f36ce3c.name
}

# EC2 instance resource with the IAM instance profile attached
resource "aws_instance" "aws_0dc7d518-2a0d-44d3-81e0-fa4c1f36ce3c" {
  ami           = "ami-090a624d5b9b3792c"
  instance_type = "t3.small"
  key_name      = "Aws2"
  vpc_security_group_ids = ["sg-038ccec9310169fce"]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_0dc7d518-2a0d-44d3-81e0-fa4c1f36ce3c.name
  hibernation = true
  tags = {
    Name = "aa-0dc7d518-2a0d-44d3-81e0-fa4c1f36ce3c"
  }
}

output "instance_id" {
  value = aws_instance.aws_0dc7d518-2a0d-44d3-81e0-fa4c1f36ce3c.id
}
