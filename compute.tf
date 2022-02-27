
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

  }
}
resource "random_id" "mssaproj_node_id" {
  byte_length = 2
  count       = var.ubuntu_instance_count
}
resource "aws_instance" "mssaproj_ubuntu" {
  count                  = var.ubuntu_instance_count
  instance_type          = var.ubuntu_instance_type
  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.deploy.id
  vpc_security_group_ids = [aws_security_group.mssaproj_sg.id]
  subnet_id              = aws_subnet.mssaproj_public_subnet[count.index].id
  
  root_block_device {
    volume_size = var.ubuntu_vol_size
  }
  tags = {
    Name = "ubuntu-${random_id.mssaproj_node_id[count.index].dec}"

  }
  provisioner "local-exec" {
    command     = "printf '\n${self.public_ip}' >> aws_hosts && aws ec2 wait instance-status-ok --instance-ids ${self.id}"
    


  }
  provisioner "local-exec" {
    when        = destroy
    command     = "sed -i '/^[0-9]/d' aws_hosts"


  }
}
resource "null_resource" "grafana_install" {
  depends_on = [aws_instance.mssaproj_ubuntu]
  provisioner "local-exec" {
    command = "ansible-playbook -i aws_hosts --key-file mssaprojkey playbooks/main_playbook.yml"
  }
}

resource "aws_key_pair" "deploy" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)

}