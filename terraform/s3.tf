resource "aws_s3_bucket" "main" {
  bucket        = "${var.project}-bucket"
  force_destroy = true
  tags = local.common_tags  
}

data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "main" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.main.arn]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.main.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}
resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.main.json
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  count = var.SNOWFLAKE_SNOWPIPE_NOTIFICATION_CHANNEL == "" ? 0 : 1
  bucket = aws_s3_bucket.main.id

  queue {
    queue_arn     = var.SNOWFLAKE_SNOWPIPE_NOTIFICATION_CHANNEL
    events        = ["s3:ObjectCreated:*"]
  }
}