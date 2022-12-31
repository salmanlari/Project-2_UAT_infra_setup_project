vpccidr = "10.0.0.0/20"
pub-subnet = {
  pub_sub-1 = {
    pub-az   = "us-east-1a"
    pub-cidr = "10.0.0.0/22"
  },
  pub_sub-2 = {
    pub-az   = "us-east-1b"
    pub-cidr = "10.0.4.0/22"
  }
}
pvt-subnet = {
  pvt_sub-1 = {
    pvt-az   = "us-east-1a"
    pvt-cidr = "10.0.8.0/22"
  },
  pvt_sub-2 = {
    pvt-az   = "us-east-1b"
    pvt-cidr = "10.0.12.0/22"
  }
}



sg_details = {

  "lb-sg" = {
    name        = "lb"
    description = "lb-sg"

    ingress_rules = [
      {
        from_port   = "80"
        to_port     = "80"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        security_groups = null
      }
    ]
  }

}


###ASG 

key-name          = "salman_nv_key"
ami-id            = "ami-0c88054e21ce3bcf0"
ec2-instance-type = "t2.micro"
desired_ec2       = "1"
min_ec2           = "1"
max_ec2           = "1"


##2
key-name-2          = "salman_nv_key"
ami-id-2            = "ami-060583bc6ad1cf02f"
ec2-instance-type-2 = "t2.micro"
desired_ec2-2       = "1"
min_ec2-2           = "1"
max_ec2-2           = "1"

