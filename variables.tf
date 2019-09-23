variable "region" {
  description = "AWS region for hosting  your network"
  default = "us-east-2"
}
variable "public_key_path" {
  description = "Enter the path to the SSH Public Key to add to AWS."
  default = "/home/ec2-user/UpdateTerra/terrakey.pem"
} 
variable "key_name" {
  description = "Key name for SSHing into EC2"
  default = "terrakey"
}
variable "amis" {
  description = "Base AMI to launch the instances"
  default = {
  us-east-2 = "ami-0c64dd618a49aeee8"
  }
}
