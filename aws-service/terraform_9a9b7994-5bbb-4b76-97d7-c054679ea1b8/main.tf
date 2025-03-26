
provider "aws" {
  region = "us-east-1"
}

# IAM Role for SSM with AmazonSSMManagedInstanceCore policy attached
resource "aws_iam_role" "ssm_role_9a9b7994-5bbb-4b76-97d7-c054679ea1b8" {
  name = "ssm_role_9a9b7994-5bbb-4b76-97d7-c054679ea1b8"
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

resource "aws_iam_role_policy_attachment" "ssm_role_attach_9a9b7994-5bbb-4b76-97d7-c054679ea1b8" {
  role       = aws_iam_role.ssm_role_9a9b7994-5bbb-4b76-97d7-c054679ea1b8.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile_9a9b7994-5bbb-4b76-97d7-c054679ea1b8" {
  name = "ssm_instance_profile_9a9b7994-5bbb-4b76-97d7-c054679ea1b8"
  role = aws_iam_role.ssm_role_9a9b7994-5bbb-4b76-97d7-c054679ea1b8.name
}

# EC2 instance resource with the IAM instance profile attached
resource "aws_instance" "aws_9a9b7994-5bbb-4b76-97d7-c054679ea1b8" {
  ami           = "ami-032ec7a32b7fb247c"
  instance_type = "t3.small"
  key_name      = "Aws2"
  vpc_security_group_ids = ["sg-038ccec9310169fce"]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_9a9b7994-5bbb-4b76-97d7-c054679ea1b8.name
  hibernation = true
  tags = {
    Name = "Ec2-9a9b7994-5bbb-4b76-97d7-c054679ea1b8"
  }
}

output "instance_id" {
  value = aws_instance.aws_9a9b7994-5bbb-4b76-97d7-c054679ea1b8.id
}
