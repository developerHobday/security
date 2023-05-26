

resource "aws_cloudtrail" "main" {
  name                          = "${var.project}-trail"
  s3_bucket_name                = aws_s3_bucket.main.id
  include_global_service_events = false
  tags = local.common_tags
}