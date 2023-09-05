#1 : Create a VPC
resource "aws_vpc" "myvpc"{
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "MyVPC"
    }
}

 #2: Create a public subnet
resource "aws_subnet" "PublicSubnet"{
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "us-east-2a"
    cidr_block = "10.0.1.0/24"
}

# 3 : create a private subnet
resource "aws_subnet" "PrivSubnet1"{
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-2a"

}
resource "aws_subnet" "PrivSubnet2"{
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.5.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-2b"

}

 #4 : create IGW
resource "aws_internet_gateway" "myIgw"{
    vpc_id = aws_vpc.myvpc.id
}

 #5 : route Tables for public subnet
resource "aws_route_table" "PublicRT"{
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myIgw.id
    }
}
 

 #7 : route table association public subnet 
resource "aws_route_table_association" "PublicRTAssociation"{
    subnet_id = aws_subnet.PublicSubnet.id
    route_table_id = aws_route_table.PublicRT.id
}
#rds subnet
resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "rds_subnet_group"
    subnet_ids = [aws_subnet.PrivSubnet1.id,aws_subnet.PrivSubnet2.id]
  
}
