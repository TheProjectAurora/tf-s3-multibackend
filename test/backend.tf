provider "aws" {}

/* This forces the failure if the account is not the correct 
   The key is not following the standard (because I don't know
   what the standard is yet...)
*/
terraform {
  backend "s3" {
  }
}
