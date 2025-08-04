provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "example" {
  ami                         = "ami-0a87a69d69fa289be"
  instance_type               = "t2.nano"
  user_data_replace_on_change = true

  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello, World" > index.html
    nohup busybox httpd -f -p ${var.server_port} &
  EOF

  tags = {
    Name = "example-instance"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = var.server_port
    to_port   = var.server_port
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

output "server_ip" {
  value = aws_instance.example.public_ip
  description = "The public IP address of the example instance"
}
