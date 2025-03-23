import datetime
import vlc
import os
import time
def get_current_time():
     return datetime.datetime.now() 

def one_hour_later(current_time):
     return current_time + datetime.timedelta(hours=1)
     

def sound_notification() -> None:
     file_path = "./clock-alarm.mp3"
     if not os.path.exists(file_path):
          print(f"File not found: {file_path}")
          return
     p = vlc.MediaPlayer(f"file://{os.path.abspath(file_path)}")
     p.play()
     time.sleep(5) # wait for the sound to finish

if __name__ == '__main__':
     current_time = get_current_time()
     next_pause = one_hour_later(current_time)
     print(f"Current time is: {current_time}")
     print(f"Next pause: {next_pause}")
    
     while True:
          if datetime.datetime.now() >= next_pause:
               sound_notification()
               print("Time to take a break (5/10 minutes), save your eyes :)")
               break
          time.sleep(1)
