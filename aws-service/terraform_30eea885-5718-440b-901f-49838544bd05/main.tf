
provider "aws" {
  region = "us-east-1"
}

# IAM Role for SSM with AmazonSSMManagedInstanceCore policy attached
resource "aws_iam_role" "ssm_role_30eea885-5718-440b-901f-49838544bd05" {
  name = "ssm_role_30eea885-5718-440b-901f-49838544bd05"
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

resource "aws_iam_role_policy_attachment" "ssm_role_attach_30eea885-5718-440b-901f-49838544bd05" {
  role       = aws_iam_role.ssm_role_30eea885-5718-440b-901f-49838544bd05.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile_30eea885-5718-440b-901f-49838544bd05" {
  name = "ssm_instance_profile_30eea885-5718-440b-901f-49838544bd05"
  role = aws_iam_role.ssm_role_30eea885-5718-440b-901f-49838544bd05.name
}

# EC2 instance resource with the IAM instance profile attached
resource "aws_instance" "aws_30eea885-5718-440b-901f-49838544bd05" {
  ami           = "ami-0fa71268a899c2733"
  instance_type = "t3.small"
  key_name      = "Aws2"
  vpc_security_group_ids = ["sg-038ccec9310169fce"]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_30eea885-5718-440b-901f-49838544bd05.name
  hibernation = true
  tags = {
    Name = "single-vm-30eea885-5718-440b-901f-49838544bd05"
  }
}

output "instance_id" {
  value = aws_instance.aws_30eea885-5718-440b-901f-49838544bd05.id
}
