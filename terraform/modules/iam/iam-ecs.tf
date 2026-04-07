
# IAM ECS TASK EXECUTION ROLE

resource "aws_iam_role" "ecs_task_execution_role_pull_image" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role_pull_image.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "execution_role_secret_access" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [
      "arn:aws:secretsmanager:eu-west-2:111810594106:secret:umami/staging/db-credentials*"
    ]
  }
}

resource "aws_iam_policy" "execution_role_secret_policy" {
  name   = "ecs-execution-secret-policy-umami"
  policy = data.aws_iam_policy_document.execution_role_secret_access.json
}

resource "aws_iam_role_policy_attachment" "execution_role_secret_attach" {
  role       = aws_iam_role.ecs_task_execution_role_pull_image.name
  policy_arn = aws_iam_policy.execution_role_secret_policy.arn
}



# IAM ECS TASK ROLES

resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole-umami"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# DATABASE URL ON AWS KSM, MANUALLY CREATED. 
data "aws_secretsmanager_secret" "db" {
  arn = "arn:aws:secretsmanager:eu-west-2:111810594106:secret:umami/staging/db-credentials"
}

data "aws_iam_policy_document" "secret_db_arn" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [
      data.aws_secretsmanager_secret.db.arn
    ]
  }
}


resource "aws_iam_policy" "ecs_task_secrets_policy" {
  name   = "ecs-task-secrets-policy-umami"
  policy = data.aws_iam_policy_document.secret_db_arn.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_secrets_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_secrets_policy.arn
}




