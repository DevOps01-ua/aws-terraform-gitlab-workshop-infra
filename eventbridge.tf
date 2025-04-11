resource "aws_cloudwatch_event_rule" "site_checker_trigger" {
  name                = "site_checker_schedule"
  schedule_expression = "rate(2 minutes)"
}

resource "aws_cloudwatch_event_target" "site_checker_lambda" {
  rule      = aws_cloudwatch_event_rule.site_checker_trigger.name
  target_id = "lambda"
  arn       = aws_lambda_function.site_checker.arn
  #arn        = module.lambda_site_checker.lambda_function_arn #for using in module
}