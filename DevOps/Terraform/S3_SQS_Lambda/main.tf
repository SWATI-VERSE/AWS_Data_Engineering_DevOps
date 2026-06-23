resource "aws_s3_bucket" "bucket" {
  bucket = "terraform-devops-assignment-bucket"
}

resource "aws_sqs_queue" "queue" {
  name = "terraform-sqs-queue"
}

resource "aws_iam_role" "lambda_role" {

  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"

      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {

  role       = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "s3_lambda" {

  filename         = "lambda.zip"

  function_name    = "s3-file-printer"

  role             = aws_iam_role.lambda_role.arn

  handler          = "lambda_function.lambda_handler"

  runtime          = "python3.12"

  source_code_hash = filebase64sha256("lambda.zip")
}

resource "aws_lambda_permission" "allow_s3" {

  statement_id = "AllowExecutionFromS3"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.s3_lambda.function_name

  principal = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {

  bucket = aws_s3_bucket.bucket.id

  lambda_function {

    lambda_function_arn = aws_lambda_function.s3_lambda.arn

    events = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_permission.allow_s3
  ]
}
