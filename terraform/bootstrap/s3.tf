resource "aws_s3_bucket" "tf_state_prod" {
  bucket = "terraform-state-prod"
  region = "eu-west-2"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
