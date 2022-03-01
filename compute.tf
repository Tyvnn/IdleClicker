###Pick our ubuntu image from amazon
data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
#NoCollusion, i mean #NoCollisions 

resource "random_id" "mssaproj_node_id" {
  byte_length = 2
  count       = var.nginx_instance_count
}
#Configure how i want the Nginx instance to be, this is OOP right guys?
resource "aws_instance" "mssaproj_ubuntu" {
  count                  = var.nginx_instance_count
  instance_type          = var.ubuntu_instance_type
  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.deploy.id
  vpc_security_group_ids = [aws_security_group.mssaproj_sg.id]
  subnet_id              = aws_subnet.mssaproj_public_subnet[count.index].id
  root_block_device {
    volume_size = var.ubuntu_vol_size
  } #8 gigs for now
  tags = {
    Name = "ubuntu-${random_id.mssaproj_node_id[count.index].dec}"
  }

  provisioner "local-exec" {###this is for ansible inventory file, and mkaes su wait till its fully up before we try and SSH
    command     = "printf '\n${self.public_ip}' >> aws_hosts && aws ec2 wait instance-status-ok --instance-ids ${self.id}"
  }
#jenkins wont let this be deleted un comment after demo  
#   provisioner "local-exec" {#removes entry from aws_hosts when they get deleted
#     when        = destroy
#     command     = "sed -i '/^[0-9]/d' aws_hosts"
#   }
}
###Keys to the City
resource "aws_key_pair" "deploy" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)

}