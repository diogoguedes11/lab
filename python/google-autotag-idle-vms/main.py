import google.auth
import logging
if __name__ == "__main__":
    try:
        # Authentication
        credentials, project = google.auth.default()
        
        # Logging DEBUG
        base_logger = logging.getLogger("google")
        base_logger.addHandler(logging.StreamHandler())
        base_logger.setLevel(logging.DEBUG)
        
    except:
        print("An error occured.")
    