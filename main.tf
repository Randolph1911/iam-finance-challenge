provider "aws" {
  region = "eu-west-1"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Create an IAM group
resource "aws_iam_group" "finance_analysts" {
  name = var.iam_group_name
}
resource "aws_s3_bucket" "finance" {
  bucket = var.iam_group_name
}
resource "aws_s3_bucket_ownership_controls" "finance" {
  bucket = aws_s3_bucket.finance.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Apply ACL to the S3 bucket
resource "aws_s3_bucket_acl" "finance" {
  depends_on = [aws_s3_bucket_ownership_controls.finance]
  bucket     = aws_s3_bucket.finance.id
  acl        = "private"
}
# Upload a file to the S3 bucket
resource "aws_s3_object" "finance_doc" {
  bucket = aws_s3_bucket.finance.bucket
  key    = var.aws_s3_object_key
  source = "${path.module}/${var.aws_s3_object_key}"
  etag   = filemd5("${path.module}/${var.aws_s3_object_key}")
}

# Define the S3 bucket policy and apply it
data "aws_iam_policy_document" "finance_analysts_policy_doc" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:*",
    ]
    resources = [
      "${aws_s3_bucket.finance.arn}",
      "${aws_s3_bucket.finance.arn}/*",
    ]
  }
}
resource "aws_iam_policy" "finance_analysts_policy" {
  name   = "finance-analysts-access"
  policy = data.aws_iam_policy_document.finance_analysts_policy_doc.json
}

resource "aws_iam_group_policy_attachment" "finance_analysts_attachment" {
  group      = aws_iam_group.finance_analysts.name
  policy_arn = aws_iam_policy.finance_analysts_policy.arn
}
