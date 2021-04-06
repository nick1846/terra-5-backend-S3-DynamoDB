provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_kms_key" "objects" {
  description             = "KMS key is used to encrypt bucket objects"
  deletion_window_in_days = 7
} 


module "my_s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-backend-s3-bucket"
  acl    = "private"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.objects.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  object_lock_configuration = {
    object_lock_enabled = "Enabled"   
    rule = {
      default_retention = {
        mode = "GOVERNANCE"
        days = 1
      }
    } 
  }

  tags = {
    Owner = "Nick"
  }
}

module "my_dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"
  
  read_capacity  = 5
  write_capacity = 5
  name           = "terraform_state"
  hash_key       = "LockID"

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}
