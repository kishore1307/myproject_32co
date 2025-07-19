resource "aws_instance" "app" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install docker -y
              service docker start
              docker run -d -p 5000:5000 kishore/app:latest
              EOF

  tags = {
    Name = "devops-app"
  }
}

output "public_ip" {
  value = aws_instance.app.public_ip
}
