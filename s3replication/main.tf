terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
      
    }
  }
}

resource "aws_s3_bucket" "source" {
  provider = aws.source
  bucket   = var.source_bucket_name
}

resource "aws_s3_bucket_website_configuration" "source" {
  bucket = aws_s3_bucket.source.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "source_policy" {
  provider = aws.source
  bucket   = aws_s3_bucket.source.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "PublicReadGetObject",
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource  = "${aws_s3_bucket.source.arn}/*"
    }]
  })
}

resource "aws_s3_bucket_versioning" "source_versioning" {
  provider = aws.source
  bucket   = aws_s3_bucket.source.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "index" {
  provider     = aws.source
  bucket       = aws_s3_bucket.source.id    # Reference your source bucket
  key          = "index.html"                # Object key in the bucket
  source       = "${path.module}/website/index.html"  # Path to your local file
  acl          = "public-read"               # Make the file publicly readable
  content_type = "text/html"                 # Content-Type header for the object
}


resource "aws_s3_bucket_website_configuration" "destination" {
  bucket = aws_s3_bucket.destination.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket" "destination" {
  provider = aws.destination
  bucket   = var.destination_bucket_name

  tags = {
    Name = var.destination_bucket_name
  }
}



resource "aws_s3_bucket_policy" "destination_policy" {
  provider = aws.destination
  bucket   = aws_s3_bucket.destination.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "PublicReadGetObject",
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource  = "${aws_s3_bucket.destination.arn}/*"
    }]
  })
}


resource "aws_s3_bucket_versioning" "destination_versioning" {
  provider = aws.destination
  bucket   = aws_s3_bucket.destination.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_role" "replication_role" {
  provider = aws.source
  name     = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "s3.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "replication_policy" {
  provider = aws.source
  name     = "s3-replication-policy"
  role     = aws_iam_role.replication_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ],
        Resource = aws_s3_bucket.source.arn
      },
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionTagging"
        ],
        Resource = "${aws_s3_bucket.source.arn}/*"
      },
      {
        Effect   = "Allow",
        Action   = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        Resource = "${aws_s3_bucket.destination.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  provider = aws.source
  bucket   = aws_s3_bucket.source.id
  role     = aws_iam_role.replication_role.arn

  depends_on = [
    aws_s3_bucket_versioning.source_versioning,
    aws_s3_bucket_versioning.destination_versioning,
    aws_iam_role_policy.replication_policy
  ]

  rule {
    id     = "replication-rule-1"
    status = "Enabled"

    delete_marker_replication {
      status = "Enabled"
    }

    destination {
      bucket        = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"
    }
  }
}
