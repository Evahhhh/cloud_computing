# === storage.tf ===

# Object Storage : S3
resource "aws_s3_bucket" "benchmark_object" {
  bucket = "benchmark-object-storage"
}

# Block Storage simule : EBS
resource "aws_ebs_volume" "benchmark_block" {
  availability_zone = "us-east-1a"
  size              = 10
  type              = "gp3"

  tags = { Name = "benchmark-block-storage" }
}
