
import argparse
import subprocess
import datetime
def main():
     parser = argparse.ArgumentParser(
          prog="Log Archive tool",
          description="archive logs on a set schedule by compressing them and storing them in a new directory, this is especially useful for removing old logs and keeping the system clean while maintaining the logs in a compressed format for future reference."
     )
     parser.add_argument('-f','--logdir',help="Log directory path")
     args = parser.parse_args()
     # if args.logdir:
     #      print('hello')
     datehour = f'{datetime.datetime.now().strftime("%Y%m%d")}_{datetime.datetime.now().strftime("%-I%-M%-S")}'
     subprocess.run(['sudo','tar','-czf', f'log_archive_{datehour}.tar.gz','/var/log'])
if __name__ == "__main__":
     main()