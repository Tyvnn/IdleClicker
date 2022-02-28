//Network Vars
variable "vpc_cidr" {
  type    = string
  default = "10.69.0.0/16"
}

variable "access_ip" {
  type    = string
  default = "104.185.37.127/32"

}
variable "cloud9_ip" {
  type = string
  default = "107.21.176.213/32"
}
//Compute Vars

variable "ubuntu_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ubuntu_vol_size" {
  type    = number
  default = 8
}

variable "ubuntu_instance_count" {
  type    = number
  default = 1

}

//security vars
variable "key_name" {
  type = string
}
variable "public_key_path" {
  type = string
}