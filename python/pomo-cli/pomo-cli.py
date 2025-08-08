import datetime
import vlc
import os
import time
def get_current_time():
     return datetime.datetime.now() 

def thirty_minutes_timer(start_time):
     return start_time + datetime.timedelta(minutes=1)
     

def pause_notification() -> None:
     player = vlc.MediaPlayer("file:///tmp/clock-alarm.mp3")
     player.play()
     time.sleep(3)  # Allow time for the sound to start playing
     print("You did it! Make yourself proud for one more pomodoro. Keep Grinding. But never forget to take a break.")


if __name__ == '__main__':
     current_time = get_current_time()
     next_pause = thirty_minutes_timer(current_time)
     print(f"Pomodoro started. Focus")
     print(f"Next break at: {next_pause.strftime('%H:%M:%S')}")
    
     while True:
          if datetime.datetime.now() >= next_pause:
               pause_notification()
               break
          time.sleep(1)
