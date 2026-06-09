# === bucket_vulnerable.tf ===
# !! CE CODE EST VOLONTAIREMENT NON SECURISE — USAGE PEDAGOGIQUE UNIQUEMENT !!

resource "aws_s3_bucket" "vulnerable" {
  bucket = "bucket-vulnerable-demo"
  # OUBLI 1 : pas de tags, pas de description
}

# Ownership controls requis pour activer les ACL
resource "aws_s3_bucket_ownership_controls" "vulnerable" {
  bucket = aws_s3_bucket.vulnerable.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# OUBLI 2 : acces public non bloque (tout desactive)
resource "aws_s3_bucket_public_access_block" "vulnerable" {
  bucket                  = aws_s3_bucket.vulnerable.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# OUBLI 3 : ACL publique — tout internet peut lire
resource "aws_s3_bucket_acl" "vulnerable_acl" {
  bucket     = aws_s3_bucket.vulnerable.id
  acl        = "public-read"
  depends_on = [
    aws_s3_bucket_ownership_controls.vulnerable,
    aws_s3_bucket_public_access_block.vulnerable
  ]
}

# OUBLI 4 : pas de chiffrement
# resource "aws_s3_bucket_server_side_encryption_configuration" ... { MANQUANT }

# OUBLI 5 : pas de versioning
# resource "aws_s3_bucket_versioning" ... { MANQUANT }

# OUBLI 6 : politique permissive — Principal: * autorise tout le monde
resource "aws_s3_bucket_policy" "vulnerable_policy" {
  bucket     = aws_s3_bucket.vulnerable.id
  depends_on = [aws_s3_bucket_public_access_block.vulnerable]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = ["s3:GetObject", "s3:ListBucket"]
      Resource = [
        "arn:aws:s3:::bucket-vulnerable-demo",
        "arn:aws:s3:::bucket-vulnerable-demo/*"
      ]
    }]
  })
}
