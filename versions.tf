terraform {
  required_version = ">= 1.10.2"
  required_providers {
    oci = {
      version = ">= 6.21.0"
    }
  }
}

/* if you're going to create the resource out of your home region
provider "oci" {
  alias        = "home-region"
  tenancy_ocid = ""
  region       = ""
}*/