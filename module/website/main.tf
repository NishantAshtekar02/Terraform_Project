#giving name to the bucket 
resource "aws_s3_bucket" "mybucket" {
  bucket = var.my_bucket_name
} 

#to give ownership controls to the bucket
resource "aws_s3_bucket_ownership_controls" "mybucket_ownership_controls" {
  bucket = aws_s3_bucket.mybucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

#to allow public access to the bucket
resource "aws_s3_bucket_public_access_block" "mybucket_public_access_block" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#to set the ACL of the bucket to public-read
resource "aws_s3_bucket_acl" "mybucket_acl" {
    depends_on = [ 
    aws_s3_bucket_public_access_block.mybucket_public_access_block,
    aws_s3_bucket_ownership_controls.mybucket_ownership_controls
    ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

#to set the policy of the bucket to allow public read access
resource "aws_s3_bucket_policy" "mybucket_policy" {
  bucket = aws_s3_bucket.mybucket.id
    depends_on = [
        aws_s3_bucket_acl.mybucket_acl,
        aws_s3_bucket_public_access_block.mybucket_public_access_block,
        aws_s3_bucket_ownership_controls.mybucket_ownership_controls
    ]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.mybucket.arn}/*"
      }
    ]
  })
}

# to create a website on s3
module "template_files"{
    source = "hashicorp/dir/template"

    base_dir = "${path.module}/Website_files"
}

# to configure the website on s3
resource "aws_s3_bucket_website_configuration" "mybucket_website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
    
  }
}

# to upload files to the s3 bucket for hosting the website
resource "aws_s3_object" "bucket_files" {
  for_each = module.template_files.files

  bucket = aws_s3_bucket.mybucket.id
  key    = each.key
  content_type = each.value.content_type
  content = each.value.content
  source = each.value.source_path
  etag   = each.value.digests.md5

  depends_on = [
    aws_s3_bucket_website_configuration.mybucket_website,
    aws_s3_bucket_acl.mybucket_acl,
    aws_s3_bucket_policy.mybucket_policy
  ]
}   