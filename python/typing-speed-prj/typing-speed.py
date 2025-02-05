import threading as th
import os
import json
import random
import time


class cliTypeTest():

  def __init__(self):
    self.points = 0
    self.wpm = 0
    self.start_time = 0
    self.total_words = 0
    self.mainMenu()
   
    

  def generate_text(self,word_count=3):
    # List of sample words (you can expand this list)
    words = ["apple", "banana", "orange", "grape", "peach", "melon", 
             "blueberry", "strawberry", "mango", "pineapple", "pear", 
             "plum", "cherry", "lemon", "lime", "watermelon", "kiwi"]

    # Generate a random sequence of words
    random_words = random.choices(words, k=word_count)
    
    # Join the list of words into a string (sentence/paragraph)
    text = ' '.join(random_words)
    return text
  
  def start_game(self):
    text = self.generate_text(10)
    print("Type the following text:\n")
    print(text)
    print("\nPress Enter to start:")
    input()
    self.start_time = time.time()
    user_input = input()
    self.end_time = time.time()
    self.calculate_results(text,user_input)

  def calculate_results(self,text,user_input):
    time_taken  = self.end_time - self.start_time
    self.total_words = len(text.split())
    correct_words = sum(1 for a, b in zip(text.split(), user_input.split()) if a == b) 
    self.wpm = (correct_words / time_taken) * 60   
    self.points = correct_words
    print(f"\nWPM: {self.wpm:.2f}, Points: {self.points}/{self.total_words}")

  def mainMenu(self):
    print("[*]------------------------------------[*]")
    print(" |----- Welcome Speed Test Game -----|")
    print("[*]------------------------------------[*]")
    time.sleep(0.1)  
    input_user = input("Are you ready to play the game?(yes or no): ")
    if input_user.lower() == "yes":
      self.start_game()
    else:
      return
    

if __name__ == "__main__":
  cliTypeTest()