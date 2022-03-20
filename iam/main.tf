# IAM Policies

# By default the user doesn't have access to any resource in AWS.

# Rules that gets applied:
# Explicit Deny
# Explicit Allow
# Default implicit Deny takes effect. 

# Creating IAM Users

resource "aws_iam_user" "sally" {
  name = "sally"
}

# Data Sources


data "aws_s3_bucket" "s3_bucket_1" {
  bucket = var.s3_bucket_1_name
}

data "aws_s3_bucket" "s3_bucket_2" {
  bucket = var.s3_bucket_2_name
}

# Resource to assign an inline policy to an IAM user.
# And denies access to a specific bucket.

resource "aws_iam_user_policy" "policy_allow_all_buckets" {
  name = "AWSAllowAllBuckets"
  user = aws_iam_user.sally.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
     "Sid": "AllowAllBuckets",
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::*"]
    },
    {
     "Sid": "DenySecondBucket",
      "Action": [
        "s3:*"
      ],
      "Effect": "Deny",
      "Resource": ["${data.aws_s3_bucket.s3_bucket_2.arn}"]
    }
  ]
}
EOF
}


# Creating groups

resource "aws_iam_group" "developers" {
  name = "developers"
}

# Policies

resource "aws_iam_group_policy" "developer_policy" {
  name  = "developer_policy"
  group = aws_iam_group.developers.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
     "Sid": "AllowAllBuckets",
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::*"]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "allow_access_to_one_policy" {
  name = "access_to_one_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:*"
        Effect   = "Allow"
        Resource = "${data.aws_s3_bucket.s3_bucket_2.arn}"
      }
    ]
  })
}

# Adding users to group

# resource "aws_iam_group_membership" "developer_team" {
#     name = "developer_team"

#     users = [
#         aws_iam_user.sally.name
#     ]

#     group = aws_iam_group.developers.name
# }