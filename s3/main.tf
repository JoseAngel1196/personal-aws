resource "random_id" "s3_bucket_1" {
  byte_length = 8
}

resource "random_id" "s3_bucket_2" {
  byte_length = 8
}

resource "aws_s3_bucket" "s3-bucket-1" {
  bucket = "bucket-${random_id.s3_bucket_1.hex}"

  tags = {
    Name = "${random_id.s3_bucket_1.hex}"
  }
}

resource "aws_s3_bucket" "s3-bucket-2" {
  bucket = "bucket-${random_id.s3_bucket_2.hex}"

  tags = {
    Name = "${random_id.s3_bucket_2.hex}"
  }
}

# Giving access to a given bucket using s3 resource policy

resource "aws_s3_bucket_policy" "allow_access_to_buckets" {
  bucket = aws_s3_bucket.s3-bucket-2.id
  policy = data.aws_iam_policy_document.allow_access_to_one_bucket.json
}

data "aws_iam_policy_document" "allow_access_to_one_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["359077644352"]
    }

    actions = ["s3:*"]

    resources = [aws_s3_bucket.s3-bucket-2.arn]
  }
}