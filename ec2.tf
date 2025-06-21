
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c94855ba95c71c99" # Amazon Linux 2 AMI for us-east-1
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              exec > /var/log/user-data.log 2>&1
              yum update -y
              yum install -y httpd git
              systemctl enable httpd
              systemctl start httpd
              cd /tmp
              git clone https://github.com/aosnotes77/host-a-static-website-on-aws.git
              cp -R host-a-static-website-on-aws/* /var/www/html/
              rm -rf host-a-static-website-on-aws
              EOF

  tags = {
    Name = "web-instance"
  }
}
