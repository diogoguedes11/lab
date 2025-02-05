import random
from turtle import Turtle, Screen


screen = Screen()
screen.setup(width=500,height=400) 
user_bet = screen.textinput(title="Make your bet",prompt="Which turtle will win the race? Enter the color: ")
colors = ["red","orange","yellow","green","blue","black"]
positions = [-60,-40,-20,0,20,40]
turtle_list = []
for turtle_index in range(0,6):
  turtle = Turtle(shape="turtle")
  turtle.color(colors[turtle_index])
  turtle.penup()
  turtle.goto(x=-240,y=positions[turtle_index])
  turtle_list.append(turtle)
  

if user_bet:
  is_race_on = True
  while is_race_on:
    for turtle in turtle_list: 
      rand_distance =  random.randint(0,10)
      turtle.forward(rand_distance)
      if turtle.xcor() > 230:
        winning_color = turtle.pencolor()
        is_race_on = False
        if winning_color == user_bet:
          print(f"You've won! the {winning_color} turtle is the winner")
        else:
          print("You lost!")
screen.exitonclick()
