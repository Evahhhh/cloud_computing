# === bucket_securise.tf ===

resource "aws_s3_bucket" "securise" {
  bucket = "bucket-securise-demo"
  tags   = { Owner = "equipe-a", Classification = "confidentiel" }
}

# CORRECTION 1 : bloquer tout acces public
resource "aws_s3_bucket_public_access_block" "securise" {
  bucket                  = aws_s3_bucket.securise.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CORRECTION 2 : chiffrement AES-256
resource "aws_s3_bucket_server_side_encryption_configuration" "securise" {
  bucket = aws_s3_bucket.securise.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# CORRECTION 3 : versioning active
resource "aws_s3_bucket_versioning" "securise" {
  bucket = aws_s3_bucket.securise.id

  versioning_configuration {
    status = "Enabled"
  }
}
