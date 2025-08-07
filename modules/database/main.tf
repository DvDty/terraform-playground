resource "aws_db_instance" "example" {
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true
  db_name             = "${var.environment}mysql"

  username = random_password.password.result
  password = random_string.username.result
}
