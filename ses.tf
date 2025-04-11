resource "aws_ses_email_identity" "emails" {
  for_each = var.emails
  email = each.value
}