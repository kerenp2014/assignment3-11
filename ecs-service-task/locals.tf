locals {

  number_of_azs = 3
  name          = "kerenp2014-ce6"
  region        = "ap-southeast-1"

  vpc_cidr = "10.255.0.0/16"
  # azs      = slice(data.aws_availability_zones.available.names, 0, local.number_of_azs)

  common_tags = {
    Name = local.name
  }

  # random = {
  #   Name = "${random_id.server.hex}"
  # }
}