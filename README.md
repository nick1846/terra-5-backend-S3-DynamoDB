# Quickstart Guide

This is My Terraform Backend repo, it stores the terraform.tfstate file in an s3 bucket and uses a dynamoDB table for state locking and consistency checking.

The repo will create backend itself. In this way, when you or a colleague run the “terraform plan” command, Terraform accesses the bucket s3 where the terraform.tfstate is stored, and compare it to what’s in your Terraform configurations to determine which changes need to be applied. At the same time, the dynamoDB table freezes its status, so that if two or more colleagues try to make changes to the infrastructure at the same time, there will be no concurrent updates that could lead to corruption of the file itself, loss of data and conflicts. 

To use this as backend add the code below to your .tf file:


1 terraform {
2   backend "s3" {
3    bucket         = "my-backend-s3-bucket"
4    key            = "terraform.tfstate"
5    region         = "us-east-2"
6    dynamodb_table = "terraform_state"
7  }
8}
9
