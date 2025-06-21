
resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt"
  image_id      = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = base64encode(<<-EOF
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
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-auto-instance"
    }
  }
}

resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  target_group_arns    = [aws_lb_target_group.app_tg.arn]
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-asg-instance"
    propagate_at_launch = true
  }
}
