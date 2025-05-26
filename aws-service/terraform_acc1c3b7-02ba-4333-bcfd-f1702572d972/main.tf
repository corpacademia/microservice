
provider "aws" {
  region = "us-east-1"
}

# IAM Role for SSM with AmazonSSMManagedInstanceCore policy attached
resource "aws_iam_role" "ssm_role_acc1c3b7-02ba-4333-bcfd-f1702572d972" {
  name = "ssm_role_acc1c3b7-02ba-4333-bcfd-f1702572d972"
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

resource "aws_iam_role_policy_attachment" "ssm_role_attach_acc1c3b7-02ba-4333-bcfd-f1702572d972" {
  role       = aws_iam_role.ssm_role_acc1c3b7-02ba-4333-bcfd-f1702572d972.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile_acc1c3b7-02ba-4333-bcfd-f1702572d972" {
  name = "ssm_instance_profile_acc1c3b7-02ba-4333-bcfd-f1702572d972"
  role = aws_iam_role.ssm_role_acc1c3b7-02ba-4333-bcfd-f1702572d972.name
}

# EC2 instance resource with the IAM instance profile attached
resource "aws_instance" "aws_acc1c3b7-02ba-4333-bcfd-f1702572d972" {
  ami           = "ami-08ded310ca86fa861"
  instance_type = "t3.small"
  key_name      = "Aws2"
  vpc_security_group_ids = ["sg-038ccec9310169fce"]

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_acc1c3b7-02ba-4333-bcfd-f1702572d972.name
  hibernation = true
  tags = {
    Name = "new single-vm-acc1c3b7-02ba-4333-bcfd-f1702572d972"
  }
}

output "instance_id" {
  value = aws_instance.aws_acc1c3b7-02ba-4333-bcfd-f1702572d972.id
}
