
data "aws_availability_zones" "available" {
  state = "available"
}
# VPC
resource "aws_vpc" "dev-vpc" {
  cidr_block       = var.vpccidr
  instance_tenancy = "default"

  tags = {
    Name = "${terraform.workspace}_vpc-1"
    # env = var.env
  }
}

# SUBNET

resource "aws_subnet" "dev-pub-snet" {
  # count = length (var.snetcidr)
  for_each          = var.pub-subnet
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = each.value ["pub-cidr"]
  availability_zone = each.value ["pub-az"]
  map_public_ip_on_launch = true

}
resource "aws_subnet" "dev-pvt-snet" {
  # count = length (var.snetcidr)
  for_each          = var.pvt-subnet
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = each.value ["pvt-cidr"]
  availability_zone = each.value ["pvt-az"]
}

#   tags = {
#     Name = "Main.${data.aws_availability_zones.available.names[count.index]}"

# }


#IGW
resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "${terraform.workspace}_igw"
  }
}

#ROUTE TABLE

resource "aws_route_table" "dev-rt" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = var.routecidr
    gateway_id = aws_internet_gateway.dev-igw.id
  }

  tags = {
    Name = "${terraform.workspace}_rt"
  }
}

#ROUTE TABLE ASSOCIATION


resource "aws_route_table_association" "dev-rta" {
  for_each       = aws_subnet.dev-pub-snet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.dev-rt.id

}




