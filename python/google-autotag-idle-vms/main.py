import google.auth
import logging
import google.cloud.logging
if __name__ == "__main__":
    try:
        # Authentication
        credentials, project = google.auth.default()
        client = google.cloud.logging.Client()
        logs = client.list_entries(page_size=10)
        for entry in logs:
            print(f"Timestamp: {entry.timestamp}")
            print(f"Log Name: {entry.log_name}")
            print(f"Resource: {entry.resource}")
            print(f"Payload: {entry.payload}")
            print(f"Severity: {entry.severity}")
            print("-" * 40)
    except google.auth.exceptions.DefaultCredentialsError as e:
            print(f"Authentication error: {e}")

    except Exception as e:
        print(f"An unexpected error occurred: {e}")
    