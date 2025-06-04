
provider "aws" {
  region = "us-east-1"
}

# IAM Role for SSM with AmazonSSMManagedInstanceCore policy attached
resource "aws_iam_role" "ssm_role_523933c0-344e-4456-8fd7-7bb2b5a51454" {
  name = "ssm_role_523933c0-344e-4456-8fd7-7bb2b5a51454"
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

resource "aws_iam_role_policy_attachment" "ssm_role_attach_523933c0-344e-4456-8fd7-7bb2b5a51454" {
  role       = aws_iam_role.ssm_role_523933c0-344e-4456-8fd7-7bb2b5a51454.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile_523933c0-344e-4456-8fd7-7bb2b5a51454" {
  name = "ssm_instance_profile_523933c0-344e-4456-8fd7-7bb2b5a51454"
  role = aws_iam_role.ssm_role_523933c0-344e-4456-8fd7-7bb2b5a51454.name
}

# EC2 instance resource with the IAM instance profile attached
resource "aws_instance" "aws_523933c0-344e-4456-8fd7-7bb2b5a51454" {
  ami           = "ami-0fab25cbd44603919"
  instance_type = "t3.small"
  key_name      = "Aws2"
  vpc_security_group_ids = ["sg-038ccec9310169fce"]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_523933c0-344e-4456-8fd7-7bb2b5a51454.name
  hibernation = true
  tags = {
    Name = "aa-523933c0-344e-4456-8fd7-7bb2b5a51454"
  }
}

output "instance_id" {
  value = aws_instance.aws_523933c0-344e-4456-8fd7-7bb2b5a51454.id
}
