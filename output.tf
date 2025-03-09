output "elastic_ip" {
  value = aws_eip.elastic_ip.public_ip
}

output "vpc_id" {
    description = "to check the vpc_id"
    value = aws_vpc.my_vpc.id
  
}

output "My_EC2" {
    value = aws_instance.My_EC2.public_ip
}