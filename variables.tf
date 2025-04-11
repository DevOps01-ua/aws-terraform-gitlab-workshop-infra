variable "target_url" {
  type = string
  default = "https://site_url"
}

variable "alert_emails" {
  type = string
  default = "email1, email2"
}

variable "emails" {
  type = map(string)
  default = {
    sre = "email1",
    devops = "email2"
  }
}