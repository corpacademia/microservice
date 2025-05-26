
provider "aws" {
  region = "us-east-1"
}

# IAM Role for SSM with AmazonSSMManagedInstanceCore policy attached
resource "aws_iam_role" "ssm_role_a2f87294-81df-420f-84f4-27966e7d523c" {
  name = "ssm_role_a2f87294-81df-420f-84f4-27966e7d523c"
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

resource "aws_iam_role_policy_attachment" "ssm_role_attach_a2f87294-81df-420f-84f4-27966e7d523c" {
  role       = aws_iam_role.ssm_role_a2f87294-81df-420f-84f4-27966e7d523c.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile_a2f87294-81df-420f-84f4-27966e7d523c" {
  name = "ssm_instance_profile_a2f87294-81df-420f-84f4-27966e7d523c"
  role = aws_iam_role.ssm_role_a2f87294-81df-420f-84f4-27966e7d523c.name
}

# EC2 instance resource with the IAM instance profile attached
resource "aws_instance" "aws_a2f87294-81df-420f-84f4-27966e7d523c" {
  ami           = "ami-08ded310ca86fa861"
  instance_type = "t3.small"
  key_name      = "Aws2"
  vpc_security_group_ids = ["sg-038ccec9310169fce"]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_a2f87294-81df-420f-84f4-27966e7d523c.name
  hibernation = true
  tags = {
    Name = "single-vm lab-a2f87294-81df-420f-84f4-27966e7d523c"
  }
}

output "instance_id" {
  value = aws_instance.aws_a2f87294-81df-420f-84f4-27966e7d523c.id
}
