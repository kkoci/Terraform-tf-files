output "s3_bucket_id" {
    value = aws_s3_bucket.secure_bucket.id
}

output "s3_bucket_arn" {
    value = aws_s3_bucket.secure_bucket.arn
}

output "s3_bucket_domain_name" {
    value = aws_s3_bucket.secure_bucket.bucket_domain_name
}

output "s3_hosted_zone_id" {
    value = aws_s3_bucket.secure_bucket.hosted_zone_id
}

output "s3_bucket_region" {
    value = aws_s3_bucket.secure_bucket.region
} 

output "kms_key" {
    value = aws_kms_key.mykey.id
} 

output "topic_kms_key" {
    value = aws_kms_key.topic_key.id
} 


