#vpc_cidr

variable "vpccidr" {

}

#ROUTE TABLE

variable "routecidr" {
  type    = string
  default = "0.0.0.0/0"

}
# variable "env" {}

#SUBNET
variable "pub-subnet" {
  type = map(object({
    pub-cidr = string
    pub-az   = string

  }))
}

variable "pvt-subnet" {
  type = map(object({
    pvt-cidr = string
    pvt-az   = string

  }))
}

###SG variable

variable "sg_details" {
  type = map(object({
    name        = string
    description = string


    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      security_groups= list(string)
      cidr_blocks = list(string)



    }))
  }))
}



#####ASG VARIABLE####

variable "key-name" {

}
variable "ami-id" {

}
variable "ec2-instance-type" {

}
variable "desired_ec2" {

}
variable "min_ec2" {

}
variable "max_ec2" {

}

###

variable "key-name-2" {

}
variable "ami-id-2" {

}
variable "ec2-instance-type-2" {

}
variable "desired_ec2-2" {

}
variable "min_ec2-2" {

}
variable "max_ec2-2" {

}

# variable "hc_ec2-2" {

# }