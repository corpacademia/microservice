
provider "aws" {
  region = "us-east-1"
}

# IAM Role for SSM with AmazonSSMManagedInstanceCore policy attached
resource "aws_iam_role" "ssm_role_642b08c0-7486-40dd-b44b-eac0216269ae" {
  name = "ssm_role_642b08c0-7486-40dd-b44b-eac0216269ae"
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

resource "aws_iam_role_policy_attachment" "ssm_role_attach_642b08c0-7486-40dd-b44b-eac0216269ae" {
  role       = aws_iam_role.ssm_role_642b08c0-7486-40dd-b44b-eac0216269ae.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile_642b08c0-7486-40dd-b44b-eac0216269ae" {
  name = "ssm_instance_profile_642b08c0-7486-40dd-b44b-eac0216269ae"
  role = aws_iam_role.ssm_role_642b08c0-7486-40dd-b44b-eac0216269ae.name
}

# EC2 instance resource with the IAM instance profile attached
resource "aws_instance" "aws_642b08c0-7486-40dd-b44b-eac0216269ae" {
  ami           = "ami-08ded310ca86fa861"
  instance_type = "t3.small"
  key_name      = "Aws2"
  vpc_security_group_ids = ["sg-038ccec9310169fce"]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_642b08c0-7486-40dd-b44b-eac0216269ae.name
  hibernation = true
  tags = {
    Name = "aws-642b08c0-7486-40dd-b44b-eac0216269ae"
  }
}

output "instance_id" {
  value = aws_instance.aws_642b08c0-7486-40dd-b44b-eac0216269ae.id
}
