### Provider Information

provider "aws" {
  access_key = "AKIAIMNEKVT7UNTTF75A"
  secret_key = "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"
  region     = "us-east-2"
}

### Data lookups 

data "aws_availability_zones" "all" {}

### Creating Security Group for EC2
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}  
 egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
## Creating Launch Configuration
resource "aws_launch_configuration" "example" {
  image_id               = "${lookup(var.amis,var.region)}"
  instance_type          = "t2.micro"
  security_groups        = ["${aws_security_group.instance.id}"]
  key_name               = "${var.key_name}"
  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y nginx
              sudo systemctl nginx start
              /bin/echo "Hello World" > /tmp/index.html
              EOF
  lifecycle {
    create_before_destroy = true
  }
}
## Creating AutoScaling Group
resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones   = ["us-east-2a"] 
  desired_capacity     = 1
  min_size             = 1
  max_size             = 2
  load_balancers       = ["${aws_elb.example.name}"]
  health_check_type    = "ELB"
  tag {
    key   = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}
## Security Group for ELB
resource "aws_security_group" "elb" {
  
 name = "terraform-example-elb"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
### Creating ELB
resource "aws_elb" "example" {
  name = "terraform-asg-example"
  availability_zones   = ["us-east-2a"]
  security_groups = ["${aws_security_group.elb.id}"]
  
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
}

### DATA lookups to fetch the public ip of intance created by Autoscaling


