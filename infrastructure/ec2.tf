resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 (update based on region)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  associate_public_ip_address = true

  key_name = "my-key" # Replace or parameterize

  tags = {
    Name = "AppServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker git
              service docker start
              docker run -d -p 80:3000 my-app
              EOF
}
