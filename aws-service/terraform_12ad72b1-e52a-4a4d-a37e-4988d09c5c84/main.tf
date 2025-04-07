
provider "aws" {
  region = "us-east-1"
}

# IAM Role for SSM with AmazonSSMManagedInstanceCore policy attached
resource "aws_iam_role" "ssm_role_12ad72b1-e52a-4a4d-a37e-4988d09c5c84" {
  name = "ssm_role_12ad72b1-e52a-4a4d-a37e-4988d09c5c84"
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

resource "aws_iam_role_policy_attachment" "ssm_role_attach_12ad72b1-e52a-4a4d-a37e-4988d09c5c84" {
  role       = aws_iam_role.ssm_role_12ad72b1-e52a-4a4d-a37e-4988d09c5c84.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile_12ad72b1-e52a-4a4d-a37e-4988d09c5c84" {
  name = "ssm_instance_profile_12ad72b1-e52a-4a4d-a37e-4988d09c5c84"
  role = aws_iam_role.ssm_role_12ad72b1-e52a-4a4d-a37e-4988d09c5c84.name
}

# EC2 instance resource with the IAM instance profile attached
resource "aws_instance" "aws_12ad72b1-e52a-4a4d-a37e-4988d09c5c84" {
  ami           = "ami-032ec7a32b7fb247c"
  instance_type = "t3.small"
  key_name      = "Aws2"
  vpc_security_group_ids = ["sg-038ccec9310169fce"]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_12ad72b1-e52a-4a4d-a37e-4988d09c5c84.name
  hibernation = true
  tags = {
    Name = "aa-12ad72b1-e52a-4a4d-a37e-4988d09c5c84"
  }
}

output "instance_id" {
  value = aws_instance.aws_12ad72b1-e52a-4a4d-a37e-4988d09c5c84.id
}
