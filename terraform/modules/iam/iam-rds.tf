
# IAM RDS USER CONFIG

resource "aws_iam_user_policy" "rds_connect_readonly" {
  name   = "rds-connect-readonly"
  user   = aws_iam_user.developer.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow"
        Action   = "rds-db:connect"
        Resource = "arn:aws:rds-db:eu-west-2:111810594106:dbuser:db-KR3QUTANJRGORXOZ5QMRLESLMA/readonly_user"
      }
    ]
  })
}

