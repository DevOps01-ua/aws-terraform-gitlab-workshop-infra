## lamda
## iam role
## iam policy + ses
## lambda layer
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_site_checker_exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "ses_send_email" {
  name = "ses_send_email_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "ses:SendEmail",
        "ses:SendRawEmail"
      ],
      Effect   = "Allow",
      Resource = "*"
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_ses" {
  name       = "lambda-ses-attachment"
  roles      = aws_iam_role.lambda_exec.arn
  policy_arn = aws_iam_policy.ses_send_email.arn
}

resource "aws_lambda_function" "site_checker" {
  function_name = "site_checker_v2"
  filename      = "lambda_function.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      TARGET_URL   = var.target_url
      ALERT_EMAILS = var.alert_emails
    }
  }

  layers = [data.aws_lambda_layer_version.requests.arn]
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.site_checker.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.site_checker_trigger.arn
}

#reorganize lambda using module
module "lambda_site_checker" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.0"

  function_name = "site_checker_v3"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  source_path   = "./lambda"
  create_package = true

  environment_variables = {
    TARGET_URL   = var.target_url
    ALERT_EMAILS = var.alert_emails
  }

  layers = [data.aws_lambda_layer_version.requests.arn]
  create_current_version_allowed_triggers = false

  cloudwatch_logs_retention_in_days = 14

  allowed_triggers = {
    cloudwatch = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.site_checker_trigger.arn
    }
  }

  attach_policy = false
  policy        = aws_iam_policy.ses_send_email.arn
}
