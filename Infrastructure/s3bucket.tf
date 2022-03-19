
resource "aws_s3_bucket" "cw-notejam-bucket" {
  bucket = "cw-notejam-bucket"

}

resource "aws_s3_bucket_acl" "cw-acl" {
  bucket = aws_s3_bucket.cw-notejam-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket" "clfront-notejam-bucket" {
  bucket = "clfront-notejam-bucket"

}

resource "aws_s3_bucket_acl" "cf-acl" {
  bucket = aws_s3_bucket.clfront-notejam-bucket.id
  acl    = "private"
}
