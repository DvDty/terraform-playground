variable "eu-central-1-ubuntu-ami" {
  type    = string
  default = "ami-0a87a69d69fa289be"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "webserver_name" {
  description = "The name to use for the webserver resources"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 Instance to use for the webserver"
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
  default     = 1
}
