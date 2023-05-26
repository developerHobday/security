resource "aws_iam_role" "main" {
  name = "${var.project}-role"

  # TODO extract variables
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = var.AWS_STORAGE_IAM_USER_ARN
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.AWS_STORAGE_EXTERNAL_ID
          }
        }
      }
    ]
  })

  inline_policy {
    name = "${var.project}-role-inlinepolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:DeleteObject",
            "s3:DeleteObjectVersion"
          ]
          Effect   = "Allow"
          Resource = "arn:aws:s3:::${aws_s3_bucket.main.id}/*"
        },
        {
          Action = [
            "s3:ListBucket",
            "s3:GetBucketLocation"
          ]
          Effect   = "Allow"
          Resource = "arn:aws:s3:::${aws_s3_bucket.main.id}"
        },
      ]
    })
  }

  tags = local.common_tags
}
