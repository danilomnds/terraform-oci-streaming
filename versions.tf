terraform {
  required_version = ">= 1.9.8"
  required_providers {
    oci = {
      version = ">= 6.17.0"
    }
  }
}

/* if you're going to create the resource out of your home region
provider "oci" {
  alias        = "home-region"
  tenancy_ocid = ""
  region       = ""
}*/