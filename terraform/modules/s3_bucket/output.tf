
#S3 BUCKET OUTPUT VARIABLE 

# OUTPUT FOR IAM TASK ROLE
output "bucket_arn" {
  value = aws_s3_bucket.website_uiid_bucket.arn
}

# OUTPUT ECS ENVIRONMENT VARIABLE
output "bucket_name" {
      value = tostring(aws_s3_bucket.website_uiid_bucket.bucket)
}
