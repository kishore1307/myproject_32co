resource "aws_db_instance" "postgres" {
  identifier = "postgres-db"
  engine = "postgres"
  allocated_storage = 20
  instance_class = "db.t3.micro"
  name = "appdb"
  username = "postgres"
  password = "changeme123"
  publicly_accessible = false
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.main.name
}

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["10.0.1.0/24"] # app subnet
  }
}
