#!/usr/bin/env python3
import subprocess
import datetime
from slack_sdk.webhook import WebhookClient

LOG_FILE = "/var/log/cpu_temp.log"

def _produce_slack_message(color, title, text, priority):
    return {
            "color": color,
            "author_name": "Alienware Temperature Monitor",
            "author_icon": "",
            "title": title,
            "title_link": "google.com",
            "text": text,
            "fields": [
                {
                    "title": "Priority",
                    "value": priority,
                    "short": "false"
                }
            ],
            "footer": "CTEvent Scraper",
        }

def get_cpu_temp():
    try:
        # Run the sensors command
        result = subprocess.run(["sensors"], capture_output=True, text=True, check=True)
        package_id_line = ""
        for line in result.stdout.splitlines():
            if "Package id 0" in line:
                package_id_line = line
        return package_id_line.split(" ")[4]
    except subprocess.CalledProcessError as e:
        print(f"Error running sensors: {e}")
    return None

def log_temperature(slack_webhook):
    temp = get_cpu_temp()
    if temp:
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_entry = f"{timestamp} - CPU Temperature: {temp}\n"
        with open(LOG_FILE, "a") as f:
            f.write(log_entry)
        tp = temp.split(".")[0][1:]
        if int(tp) > 92:
            slack_webhook.send(attachments=[
                _produce_slack_message("#ab1a13", "Temperature Has Reached Above 92C", f"The Temperature at {timestamp} was {temp}.", "High")
            ])

if __name__ == "__main__":
    WEBHOOK_TOKEN = ""
    log_temperature(WebhookClient(WEBHOOK_TOKEN))
