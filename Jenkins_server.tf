provider "aws" {
  region = "ap-south-1"

}

terraform {
  backend "s3" {
    bucket         = "jenkins-bucket-mumbai"
    key            = "JenkinsProject/terraform.tfstate"
    dynamodb_table = "Jenkins_lock"
    region         = "ap-south-1"
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true
}

resource "aws_instance" "myec2Jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = "Jenking_Terraform"
  tags = {
    Name = "Jenkins_server"
  }

}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.Jenkins.id
  network_interface_id = aws_instance.myec2Jenkins.primary_network_interface_id
}

resource "aws_eip" "JenkinsEIP" {
  instance = aws_instance.myec2Jenkins.id
  vpc      = true
}




