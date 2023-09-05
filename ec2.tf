resource "aws_instance" "web" {
    ami = "ami-024e6efaf93d85776"
    instance_type = "t2.micro"
#Here This line attach the created security group into ec2
    security_groups = [aws_security_group.TF_SG.name]
    key_name = "Demo"

    tags = {
        Name= "HEllo_TWS"
    }
  
}
#keypair second method for Key_pair

# resource "aws_key_pair" "TF_key" {
#   key_name   = "TF_key"
#   public_key = tls_private_key.rsa.public_key_openssh
# }

# resource "tls_private_key" "rsa" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# #store private key in your folder
# resource "local_file" "TF-key" {
#     content  = tls_private_key.rsa.private_key_pem
#     filename = "tfkey"
# }

#securitygroup using Terraform

resource "aws_security_group" "TF_SG" {
  name        = "security group using Terraform"
  description = "security group using Terraform"
  vpc_id      = "vpc-0a18a6d408b45eafe"

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
    ingress {
    description      = "Custom TCP Rule"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TF_SG"
  }
}
#RDS Instance
resource "aws_db_instance" "rds_instance" {
    engine = "mysql"
    engine_version = "5.7"
    skip_final_snapshot = true
    instance_class = "db.t2.micro"
    db_name = "mydb"
    username = "sur"
    password = "LearnEarn1M$"
    allocated_storage = 20
    identifier = "myrds-instance"
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
}


#An empty resource blok
resource "null_resource" "name" {


    #ssh into the ec2 instance
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("~/Desktop/DEVOPs/Terrform/Demo.pem")
      host =  aws_instance.web.public_ip
    }


    #copy the password file for docker hub
    provisioner "file" {
        source = "~/Documents/P/password.txt"
        destination = "/home/ubuntu/password.txt"
    }

    #copy the dockerfile 
    provisioner "file" {
        source = "Dockerfile"
        destination = "/home/ubuntu/Dockerfile"
    }
    #copy the script

    provisioner "file" {
        source = "Build_dockerimage.sh"
        destination = "/home/ubuntu/Build_dockerimage.sh"
    }
    # set permissions and run the build_docker_image.sh file
    provisioner "remote-exec" {
    inline = [
        "sudo chmod 400 /home/ubuntu/Build_dockerimage.sh",
        "sh /home/ubuntu/Build_dockerimage.sh",
    ]
    }
     # wait for ec2 to be created
  depends_on = [aws_instance.web] 
  
}
# print the url of the container
output "container_url" {
  value = join("", ["http://", aws_instance.web.public_dns])
}