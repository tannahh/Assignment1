variable "ami" {
    description = "Type of AMI for EC2"
    type = string
    default =  "ami-08b5b3a93ed654d19"
}

variable "instance_type" {
    description = "Type of the instance for EC2"
    type = string
    default = "t2.micro"
}

