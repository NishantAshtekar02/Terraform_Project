output "website_url" {
    description = "My website URL"
    value = aws_s3_bucket_website_configuration.mybucket_website.website_endpoint
 
}