data "aws_caller_identity" "current" {}

resource "aws_iam_role" "appsync_role" {
  name = "appsync_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "appsync.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "appsync_custom_policy" {
  name        = "appsync_scanner_custom_policy"
  description = "Policy for appsync to access dynamodb for CRUD operations"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:BatchGetItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:BatchWriteItem"
        ],
        Resource = [
          "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.dynamodb_table_name}"
        ]
      },

      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
      }

    ]
  })
  tags = {
    Name = "appsync_custom_policy"
  }
}

resource "aws_iam_role_policy_attachment" "attach_appsync_policy" {
  role       = aws_iam_role.appsync_role.name
  policy_arn = aws_iam_policy.appsync_custom_policy.arn
}



