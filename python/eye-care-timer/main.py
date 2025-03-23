import datetime
import vlc
import os
import time
def get_current_time():
     current_time = datetime.datetime.now()
     return current_time

def one_hour_later(get_current_time):
     one_hour_later =  get_current_time + datetime.timedelta(hours=1)
     return one_hour_later

def sound_notification() -> None:
     file_path = "./clock-alarm.mp3"
     p = vlc.MediaPlayer(f"file://{os.path.abspath(file_path)}")
     p.play()
     time.sleep(5)
if __name__ == '__main__':
     print(f"Current time is: {get_current_time()}")
     print(f"Next pause: {one_hour_later(get_current_time())}")
     while True:
          if get_current_time() == one_hour_later(get_current_time()):
               sound_notification()
               break
