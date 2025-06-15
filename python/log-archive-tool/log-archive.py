
import argparse
import os
import subprocess
from datetime import datetime

DEFAULT_VAR_LOCATION = '/var/log'
OUTPUT_DIR = './archive'

def main():
     parser = argparse.ArgumentParser(
          prog="Log Archive tool",
          description="archive logs on a set schedule by compressing them and storing them in a new directory, this is especially useful for removing old logs and keeping the system clean while maintaining the logs in a compressed format for future reference."
     )
     parser.add_argument('-f','--logdir',help="Log directory path")
     args = parser.parse_args()
     datehour = f"{datetime.now().strftime('%Y%m%d_%H%M%S')}"
     archive_name = f'log_archive_{datehour}.tar.gz'
     archive_path = os.path.join(OUTPUT_DIR,archive_name)
     print(archive_path)
     logdir = args.logdir if args.logdir else DEFAULT_VAR_LOCATION
     if not os.path.exists(logdir):
          print(f"The path: {logdir} does not exist")
     os.makedirs(OUTPUT_DIR, exist_ok=True)
     try:
          subprocess.run(['sudo','tar','-czf', archive_path, logdir])
     except Exception as e:
          print(f"Error while arquiving logs {str(e)}")
     
if __name__ == "__main__":
     main()