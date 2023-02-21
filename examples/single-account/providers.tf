provider "aws" {
  alias   = "management"
  region  = "eu-central-1"
  profile = "management"
}

provider "aws" {
  alias   = "source"
  region  = "eu-central-1"
  profile = "dev"
}
