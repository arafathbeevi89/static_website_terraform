resource "aws_s3_bucket" "static-website24" {
  bucket = var.bucketname
}

resource "aws_s3_bucket_ownership_controls" "static_ownership_controls" {
  bucket = aws_s3_bucket.static-website24.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "static_public_access_block" {
  bucket = aws_s3_bucket.static-website24.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "static_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.static_ownership_controls,
    aws_s3_bucket_public_access_block.static_public_access_block,
  ]

  bucket = aws_s3_bucket.static-website24.id
  acl    = "public-read"
}
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.static-website24.id
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.static-website24.id
  key    = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.static-website24.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  depends_on = [aws_s3_bucket_acl.static_bucket_acl]
}

