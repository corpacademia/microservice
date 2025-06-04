
provider "aws" {
  region = "us-east-1"
}

# IAM Role for SSM with AmazonSSMManagedInstanceCore policy attached
resource "aws_iam_role" "ssm_role_8fcb35d8-fbb0-4581-959a-55b16812a88f" {
  name = "ssm_role_8fcb35d8-fbb0-4581-959a-55b16812a88f"
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

resource "aws_iam_role_policy_attachment" "ssm_role_attach_8fcb35d8-fbb0-4581-959a-55b16812a88f" {
  role       = aws_iam_role.ssm_role_8fcb35d8-fbb0-4581-959a-55b16812a88f.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile_8fcb35d8-fbb0-4581-959a-55b16812a88f" {
  name = "ssm_instance_profile_8fcb35d8-fbb0-4581-959a-55b16812a88f"
  role = aws_iam_role.ssm_role_8fcb35d8-fbb0-4581-959a-55b16812a88f.name
}

# EC2 instance resource with the IAM instance profile attached
resource "aws_instance" "aws_8fcb35d8-fbb0-4581-959a-55b16812a88f" {
  ami           = "ami-0c31c2007d48fa97f"
  instance_type = "t3.small"
  key_name      = "Aws2"
  vpc_security_group_ids = ["sg-038ccec9310169fce"]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_8fcb35d8-fbb0-4581-959a-55b16812a88f.name
  hibernation = true
  tags = {
    Name = "aa-8fcb35d8-fbb0-4581-959a-55b16812a88f"
  }
}

output "instance_id" {
  value = aws_instance.aws_8fcb35d8-fbb0-4581-959a-55b16812a88f.id
}
