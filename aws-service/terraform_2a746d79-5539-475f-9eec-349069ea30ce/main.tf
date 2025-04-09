
provider "aws" {
  region = "us-east-1"
}

# IAM Role for SSM with AmazonSSMManagedInstanceCore policy attached
resource "aws_iam_role" "ssm_role_2a746d79-5539-475f-9eec-349069ea30ce" {
  name = "ssm_role_2a746d79-5539-475f-9eec-349069ea30ce"
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

resource "aws_iam_role_policy_attachment" "ssm_role_attach_2a746d79-5539-475f-9eec-349069ea30ce" {
  role       = aws_iam_role.ssm_role_2a746d79-5539-475f-9eec-349069ea30ce.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile_2a746d79-5539-475f-9eec-349069ea30ce" {
  name = "ssm_instance_profile_2a746d79-5539-475f-9eec-349069ea30ce"
  role = aws_iam_role.ssm_role_2a746d79-5539-475f-9eec-349069ea30ce.name
}

# EC2 instance resource with the IAM instance profile attached
resource "aws_instance" "aws_2a746d79-5539-475f-9eec-349069ea30ce" {
  ami           = "ami-090a624d5b9b3792c"
  instance_type = "t3.small"
  key_name      = "Aws2"
  vpc_security_group_ids = ["sg-038ccec9310169fce"]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_2a746d79-5539-475f-9eec-349069ea30ce.name
  hibernation = true
  tags = {
    Name = "aws ec2 instance-2a746d79-5539-475f-9eec-349069ea30ce"
  }
}

output "instance_id" {
  value = aws_instance.aws_2a746d79-5539-475f-9eec-349069ea30ce.id
}
