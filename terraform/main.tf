data "template_file" "asg_instance_exec" {
  template = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install git -y
    sudo apt install python3-pip -y
    cd /tmp
    sudo git clone https://github.com/burnsie7/hello-tf.git
    pip install -r ./hello-tf/requirements.txt
    sudo chmod +x ./hello-tf/assets/setup-web.sh
    sudo sh ./hello-tf/assets/setup-web.sh
  EOF
}

data "template_file" "test_this" {
  template = <<-EOF
      #!/bin/bash
      echo "Hello, World" > index.html
      nohup busybox httpd -f -p 8080 &
    EOF
}

resource "aws_launch_template" "hello_template" {
  name_prefix   = "hello_template"
  image_id      = var.ami_id
  instance_type = var.instance_size
  key_name      = var.cli_pem
  user_data     = base64encode(data.template_file.test_this.rendered)
  tags = {
    Name = "Launch Template from Tag"
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ASG Server"
    }
  }
}

resource "aws_autoscaling_group" "hello_asg" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 3
  max_size           = 5
  min_size           = 3

  launch_template {
    id      = aws_launch_template.hello_template.id
    version = "$Latest"
  }
}

resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = var.instance_size
  key_name      = "pzn_cli"
  tags = {
    Name = "Individual Instance"
  }
  user_data_replace_on_change = true
  user_data                   = base64encode(data.template_file.asg_instance_exec.rendered)
}
