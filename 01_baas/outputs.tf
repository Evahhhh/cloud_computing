# === outputs.tf ===

output "dynamodb_users_table" {
  value       = aws_dynamodb_table.users.name
  description = "Nom de la table DynamoDB utilisateurs"
}

output "dynamodb_sessions_table" {
  value       = aws_dynamodb_table.sessions.name
  description = "Nom de la table DynamoDB sessions"
}

output "s3_user_files_bucket" {
  value       = aws_s3_bucket.user_files.id
  description = "Nom du bucket S3 pour les fichiers utilisateurs"
}

output "baas_app_role_arn" {
  value       = aws_iam_role.baas_app_role.arn
  description = "ARN du role IAM pour l'application BaaS"
}
