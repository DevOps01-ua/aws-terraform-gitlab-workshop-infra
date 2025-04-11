import os
import logging
import requests
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ses = boto3.client('ses')

def send_alert_emails(subject, message):
    emails = os.environ.get("ALERT_EMAILS", "")
    recipient_list = [email.strip() for email in emails.split(",") if email.strip()]
    for email in recipient_list:
        ses.send_email(
            Source=email,
            Destination={"ToAddresses": [email]},
            Message={
                "Subject": {"Data": subject},
                "Body": {"Text": {"Data": message}}
            }
        )

def lambda_handler(event, context):
    url = os.environ.get("TARGET_URL")
    try:
        response = requests.get(url, timeout=5)
        if response.status_code != 200:
            send_alert_emails("Site is down", f"{url} returned {response.status_code}")
    except Exception as e:
        send_alert_emails("Site unreachable", str(e))
