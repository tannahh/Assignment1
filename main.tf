resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      name = "assignment_vpc"
    }
  
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
    tags = {
      name = "Public_Subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"
    tags = {
      name = "Private_Subnet"
    }
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        name = "my_igw"
    }
  
}

resource "aws_route_table" "rt_public_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  
}

resource "aws_route_table_association" "rt_public_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.rt_public_subnet.id
}

resource "aws_security_group" "EC2_sg" {
    vpc_id = aws_vpc.my_vpc.id
    ingress  {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
    tags = {
        Name = "Webserver security group"
    }
  


}

resource "aws_eip" "elastic_ip" {
    domain = "vpc"
    tags = {
        Name = "ElasticIP"
    }
}

resource "aws_instance" "My_EC2" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.public_subnet.id
    security_groups = [aws_security_group.EC2_sg.id]

    user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              echo "<h1>Welcome to My Terraform Web Server</h1>" > /var/www/html/index.html
              systemctl start httpd
              systemctl enable httpd
              EOF
              
    tags = {
      name = "VPC_EC2"
    }
}

resource "aws_eip_association" "eip_assoc" {
    instance_id = aws_instance.My_EC2.id
    allocation_id = aws_eip.elastic_ip.id
}

