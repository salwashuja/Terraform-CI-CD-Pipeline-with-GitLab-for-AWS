resource "aws_instance" "ec2_instance" {
  ami = "ami-00beae93a2d981137"
  instance_type = "t2.micro"
  subnet_id = var.sn
  security_groups = [var.sg]

  tags = {
    Name = "myinstance"

  }

}