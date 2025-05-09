import google.auth
import logging
from google.cloud.logging import DESCENDING
import argparse
import sys
#TODO: Add arg parse here and filter logs through Severity

# Setting up logging configuration
logging.basicConfig(level=logging.INFO, format='[%(levelname)s] %(message)s')

def get_client() -> google.cloud.logging.Client:
    """Authenticates and retrieves the Google Cloud clietn"""
    credentials, project = google.auth.default()
    client = google.cloud.logging.Client()
    logging.info(f"Fetching logs from project {project}")
    return client

def fetch_logs(client: google.cloud.logging.Client,severity: str):
    logs = client.list_entries(page_size=10,order_by=DESCENDING)
    return filter(lambda x: x.severity == severity,logs)

def main():
    parser = argparse.ArgumentParser(
                    prog='python3 main.py',
                    description='Retrieves logs from Google Cloud',
                    )
    parser.add_argument('-s','--severity',choices=["INFO","CRITICAL","ERROR","DEBUG"],help="Choose between: 'INFO','ERROR', 'DEBUG','CRITICAL'",required=True)
    args = parser.parse_args()
    try:
        for entry in fetch_logs(client=get_client(),severity=args.severity):
                print(f"Timestamp: {entry.timestamp}")
                print(f"Log Name: {entry.log_name}")
                print(f"Resource: {entry.resource}")
                print(f"Payload: {entry.payload}")
                print(f"Severity: {entry.severity}")
                print("-" * 50)
    except google.auth.exceptions.DefaultCredentialsError as e:
            print(f"Authentication error: {e}")
            sys.exit(1)
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
    