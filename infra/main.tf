resource "aws_lambda_function" "cloudresumetest-api" {
  filename         = data.archive_file.zip_the_python_code.output_path
  source_code_hash = data.archive_file.zip_the_python_code.output_base64sha256
  function_name    = "cloudresumetest-api"
  role             = aws_iam_role.CloudResume.arn
  handler          = "view_counter.lambda_handler"
  runtime          = "python3.13"
}
resource "aws_dynamodb_table" "cloudresume-test" {
  name           = "cloudresume-test"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"  

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_s3_bucket" "cloud-resume-challenge-cnw" {
  bucket = "cloud-resume-challenge-cnw"
}

resource "aws_s3_bucket_policy" "cloudfront_policy" {
  bucket = aws_s3_bucket.cloud-resume-challenge-cnw.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "cloudfront.amazonaws.com"
      }
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.cloud-resume-challenge-cnw.arn}/*"
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
        }
      }
    }]
  })
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "cloud-resume-challenge-cnw.s3.us-east-1.amazonaws.com"
  description                       = "OAC for CloudFront to access S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.cloud-resume-challenge-cnw.bucket_regional_domain_name}"
    origin_id   = "S3-cloud-resume-challenge-cnw"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["cameronnwilson.com", "www.cameronnwilson.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-cloud-resume-challenge-cnw"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

price_class = "PriceClass_100"

restrictions {
    geo_restriction {
      restriction_type = "none"
    }
}

viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:us-east-1:051826710466:certificate/e298a867-8cb5-4ab8-ab37-6a4480ead708"
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }
}

resource "aws_route53_zone" "main" {
  name = "cameronnwilson.com"
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "cameronnwilson.com"
  type    = "A"
  alias {
    name                   = "dyzxmqdljo8xc.cloudfront.net."
    zone_id                = "Z2FDTNDATAQYW2"  
    evaluate_target_health = false
  }
}

resource "aws_iam_role" "CloudResume" {
  name        = "CloudResume"
  description = "Allows Lambda functions to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_resume_project" {
  name        = "aws_iam_policy_for_terraform_resume_project_policy"
  path        = "/"
  description = "AWS IAM Policy for managing the resume project role"
  policy      = jsonencode(
  {
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
        Effect   = "Allow"
      },
      {
        Effect   = "Allow"
        Action   = [
          "dynamodb:UpdateItem",
          "dynamodb:GetItem"
        ]
        Resource = "arn:aws:dynamodb:*:*:table/cloudresume-test"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.CloudResume.name
  policy_arn = aws_iam_policy.iam_policy_for_resume_project.arn
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_file = "${path.module}/lambda/view_counter.py"
  output_path = "${path.module}/lambda/view_counter.zip"
}

resource "aws_lambda_function_url" "url1" {
  function_name      = aws_lambda_function.cloudresumetest-api.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_lambda_permission" "allow_public_access" {
  statement_id  = "AllowPublicAccess"
  action        = "lambda:InvokeFunctionUrl"
  function_name = aws_lambda_function.cloudresumetest-api.function_name
  principal     = "*"
  function_url_auth_type = "NONE"
}

