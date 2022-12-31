provider "aws" {
   region = "us-east-1"


}


terraform {
  backend "s3" {
    bucket = "mylab321"
    key    = "tf_state_file"
    dynamodb_table = "test"
    region = "us-east-1"
  }
}


module "nw" {
  source     = "./module/nw"
  vpccidr    = var.vpccidr
  pub-subnet = var.pub-subnet

  pvt-subnet = var.pvt-subnet

  # is_nat_required  = false
  #     nat-pub-id   ="pub_sub-1"
  # env = "dev"
}



module "sg" {
  source     = "./module/sg"
  sg_details = var.sg_details
  vpc_id     = module.nw.dev-vpc-id

 }
 
module "sg-2" {
  source     = "./module/sg"
    vpc_id     = module.nw.dev-vpc-id
   sg_details ={
     "asg-nginx-sg" = {
    name        = "nginx"
    description = "nginx-sg-2"

    ingress_rules = [
      {
        from_port   = "80"
        to_port     = "80"
        protocol    = "http"
      
         security_groups = module.sg.dev-sg-id
        cidr_blocks = null
      }
    ]
  }
  }
  
   
}



module "sg-3" {
  source     = "./module/sg"
     vpc_id     = module.nw.dev-vpc-id
  sg_details ={
     "lb-tomcat-sg" = {
    name        = "lb-2"
    description = "lb-sg-2"

    ingress_rules = [
      {
        from_port   = "80"
        to_port     = "80"
        protocol    = "http"
        security_groups = module.sg-2.dev-sg-id
        cidr_blocks = null
      }
    ]
  }
  }
 

}

module "sg-4" {
  source     = "./module/sg"
     vpc_id     = module.nw.dev-vpc-id
  sg_details ={
     "asg-tomcat-sg" = {
    name        = "tomcat-2"
    description = "tomcat-sg-2"

    ingress_rules = [
      {
        from_port   = "8080"
        to_port     = "8080"
        protocol    = "http"
        security_groups = module.sg-3.dev-sg-id
        cidr_blocks = null
      }
    ]
  }
  }


}


# #LOAD BALANCER MODULE

module "lb" {
  source    = "./module/lb"
  alb-type  = false
  sg_groups = [lookup(module.sg.dev-sg-id, "lb-sg", null)]
  snets1    = [lookup(module.nw.dev-snet-id, "pub_sub-1", null).id, lookup(module.nw.dev-snet-id, "pub_sub-2", null).id]
  vpc-id    = module.nw.dev-vpc-id
  tg-type   = "instance"
  port      = 80


  alb-type-2  = false
  sg_groups-2 = [lookup(module.sg-3.dev-sg-id, "lb-tomcat-sg", null)]
  snets2      = [lookup(module.nw.dev-snet-id, "pub_sub-1", null).id, lookup(module.nw.dev-snet-id, "pub_sub-2", null).id]
  vpc-id-2    = module.nw.dev-vpc-id
  tg-type-2   = "instance"
  port-2      = 8080

}

# # #AUTO SCALING MODULE

module "asg" {
  source = "./module/asg"
  # sg_groups         = [lookup(module.sg-2.dev-sg-id, "asg-nginx-sg", null)]
  key-name          = var.key-name
    pub-snet          = [lookup(module.nw.dev-snet-id, "pub_sub-1", null).id, lookup(module.nw.dev-snet-id, "pub_sub-2", null).id]
  # availability_zones= [lookup(module.nw.dev-snet-id, "pub_sub-1", null).id] #lookup(module.nw.dev-snet-id, "pub_sub-2", null).id]
  ami-id            = var.ami-id
  ec2-instance-type = var.ec2-instance-type
  desired_ec2       = var.desired_ec2
  min_ec2           = var.min_ec2
  max_ec2           = var.max_ec2
}

module "asg-2" {
  source = "./module/asg"
  # sg_groups         = [lookup(module.sg-2.dev-sg-id, "asg-tomcat-sg", null)]
  key-name          = var.key-name-2
    pub-snet          = [lookup(module.nw.dev-snet-id, "pub_sub-1", null).id, lookup(module.nw.dev-snet-id, "pub_sub-2", null).id]
  # availability_zones= [lookup(module.nw.dev-snet-id, "pub_sub-1", null).id] #lookup(module.nw.dev-snet-id, "pub_sub-2", null).id]
  ami-id            = var.ami-id-2
  ec2-instance-type = var.ec2-instance-type-2
  desired_ec2       = var.desired_ec2-2
  min_ec2           = var.min_ec2-2
  max_ec2           = var.max_ec2-2
}

# module "asg" {
#   source            = "./module/asg"
#   sg_groups         = [lookup(module.sg-2.dev-sg-id, "asg-nginx-sg", null)]
#   key-name          = var.key-name
#   pub-snet          = [lookup(module.nw.dev-snet-id, "pub_sub-1", null).id, lookup(module.nw.dev-snet-id, "pub_sub-2", null).id]
#   tg-arn            = module.lb.tg-arn
#   ami-id            = var.ami-id
#   ec2-instance-type = var.ec2-instance-type
#   desired_ec2       = var.desired_ec2
#   min_ec2           = var.min_ec2
#   max_ec2           = var.max_ec2
#   hc_ec2            = var.hc_ec2

#   ########

#   sg_groups-2         = [lookup(module.sg-4.dev-sg-id, "asg-tomcat-sg", null)]
#   key-name-2          = var.key-name-2
#   pub-snet-2          = [lookup(module.nw.dev-snet-id, "pub_sub-1", null).id, lookup(module.nw.dev-snet-id, "pub_sub-2", null).id]
#   tg-arn-2            = module.lb.tg-arn-2
#   ami-id-2            = var.ami-id-2
#   ec2-instance-type-2 = var.ec2-instance-type-2
#   desired_ec2-2       = var.desired_ec2-2
#   min_ec2-2           = var.min_ec2-2
#   max_ec2-2           = var.max_ec2-2
#   hc_ec2-2            = var.hc_ec2-2

# }

module "cdn" {
  source = "./module/cdn"
  domian_name=module.lb.lb_dns_output
  origin_id="lb-origin"
  # log_bucket= 
  origin_http_port="80"
  origin_https_port="443"
  origin_protocol_policy="match-viewer"
  origin_ssl_protocols=["TLSv1.2"]
  
}

module "route53" {
  source = "./module/route53"
  cdn_dns_name = module.cdn.cdn_dns_name_output
  cdn_zone_id = module.cdn.zone_id_output

  lb-2_dns_name= module.lb.lb_2_dns_output
  lb-2_zone_id= module.lb.lb_2_zone_id_output

  
}

module "s3" {
  source = "./module/s3"
  bucket_name = "atrtifact321"
  acl ="private"
}


