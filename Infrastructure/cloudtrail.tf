data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "foobar" {
  name                          = "tf-trail-foobar"
  s3_bucket_name                = aws_s3_bucket.cloudtrail-logs-s3-iam.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = true
  event_selector {
    read_write_type = "All"
    include_management_events = true

    data_resource {
      type = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }
  depends_on = [
    aws_s3_bucket.cloudtrail-logs-s3-iam,
    aws_s3_bucket_policy.new-policy
  ]
}


resource "aws_s3_bucket" "cloudtrail-logs-s3-iam" {
  bucket = "cloudtrail-logs-s3-iam"
}

resource "aws_s3_bucket_policy" "new-policy" {
  bucket        = "cloudtrail-logs-s3-iam"
  depends_on = [
    aws_s3_bucket.cloudtrail-logs-s3-iam
  ]

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::cloudtrail-logs-s3-iam"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::cloudtrail-logs-s3-iam/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}