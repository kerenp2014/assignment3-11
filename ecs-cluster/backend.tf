terraform {
  backend "s3" {
    bucket = "sctp-ce6-tfstate"
    key    = "kerenp2014-ce6-mod3.11-ecs-cluster.tfstate"
    region = "ap-southeast-1"
  }
}

