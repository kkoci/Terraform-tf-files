provider "aws" {
  region = "us-east-2"
  profile = "default"
  // assume_role {
  //   role_arn = "arn:aws:iam::657748075061:user/kkoci"
  // }
}

resource "aws_kms_key" "mykey" {
  description             = "KMS key 1"
  deletion_window_in_days = 7
}

resource "aws_s3_bucket" "log_the_hell_of_this_123456" {
  bucket = "3bn-log-bucket"
  force_destroy = true
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket" "secure_bucket" {
  bucket = "secure-3bn-bucket"
  acl    = "private"

  logging {
    target_bucket = aws_s3_bucket.log_the_hell_of_this_123456.id
    target_prefix = "log/"
  }

  versioning {
    enabled    = true
    // mfa_delete = true
  }

  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    owner = "3bngnome"
  }
}

resource "aws_s3_bucket_notification" "notif" {
  bucket = aws_s3_bucket.secure_bucket.id

  topic {
    topic_arn = aws_sns_topic.topic.arn

    events = [
      "s3:ObjectCreated:*",
    ]

  }
}

resource "aws_s3_bucket_public_access_block" "public_block_3bn" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_vpc" "test_vpc_3bn" {
  cidr_block = "172.16.0.0/16"

}

resource "aws_security_group" "test_3bn" {
  vpc_id = aws_vpc.test_vpc_3bn.id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    iterator = port
    for_each = var.egress_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

