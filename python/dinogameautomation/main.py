import pyautogui
import webbrowser
import time
from PIL import Image

URL = "https://chromedino.com/"

def is_obstacle_present():
    # Capture a screenshot of the game region
    im = pyautogui.screenshot()
    # Convert the screenshot to a format we can manipulate (Pillow Image)
    im.convert('RGB')
    screen = im.getpixel((252,219))
    
    x1 = im.getpixel((548,307))
    print(screen[0])
    if screen[0] == 255:
        print("Yes screen")
        if x1[0] != 255:
            print("Yes")
            return True
    else:
        if x1[0] != 0:
            print("Yes different than 0")
            return True

    return False  # Return False if no dark pixels are found

def main():
    webbrowser.open(URL)  
    time.sleep(3)
    pyautogui.press('space')  # Jump to start the game

    # Continuously check for obstacles
    while True:
        if is_obstacle_present():
            pyautogui.press('space')  # Jump if an obstacle is detected
        time.sleep(0.1)  # Adjust the sleep time as necessary

if __name__ == "__main__":
    main()