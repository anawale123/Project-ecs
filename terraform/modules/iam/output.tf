# ECS TASK ROLE IAM
output "image_pull_arn" {
  value       = aws_iam_role.ecs_task_execution_role_pull_image.arn
  description = "IAM role for pulling images from ECR"
 
}

output "secret_db_arn" {
  value        = data.aws_secretsmanager_secret.db.arn
  description  = " database url arn " 
}

# AWS KSM SECRET - ENV DATABASE URL
output "secret_db_task_role_arn" {
  value       = aws_iam_role.ecs_task_role.arn
  description = "IAM role used by ECS tasks to read Secrets Manager"
}

# ECS TASK ROLE 
output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
   
}

# ECS CODE DEPLOY 

output "codedeploy_role_arn" {
  value = aws_iam_role.code_deploy_service_role.arn
}
