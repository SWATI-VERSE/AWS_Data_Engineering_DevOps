output "bucket_name" {
  value = aws_s3_bucket.bucket.id
}

output "lambda_name" {
  value = aws_lambda_function.s3_lambda.function_name
}

output "queue_name" {
  value = aws_sqs_queue.queue.name
}
