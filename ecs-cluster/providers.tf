provider "aws" {
  alias = "ap_southeast_1"
  region = local.region
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}