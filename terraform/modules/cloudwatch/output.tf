
# CLOUDWATCH ECS TASK (UMAMI) OUTPUT VARIABLE
output "cloudwatch" {
    description    =     " cloudwatch output" 
    value          =     aws_cloudwatch_log_group.umami_logs.name
}

