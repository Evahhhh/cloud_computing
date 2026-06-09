# === iam.tf ===

# Role permettant a une application d'acceder aux ressources BaaS
resource "aws_iam_role" "baas_app_role" {
  name = "baas-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = { Service = "BaaS", ManagedBy = "terraform" }
}

# Policy : acces DynamoDB et S3 pour l'application
resource "aws_iam_role_policy" "baas_app_policy" {
  name = "baas-app-policy"
  role = aws_iam_role.baas_app_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          aws_dynamodb_table.users.arn,
          aws_dynamodb_table.sessions.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.user_files.arn}/*"
      }
    ]
  })
}
