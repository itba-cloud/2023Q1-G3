resource "aws_lambda_function" "this" {
  filename      = local.zip_file_name
  function_name = var.function_name
  role          = local.lab_role
  #function that handles the event
  handler       = local.handler
  runtime       = var.runtime

  tags = {
    name = "Lambda ${var.function_name}"
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_groups
  }

  depends_on = [
    data.archive_file.this
  ]
}