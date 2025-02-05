from turtle import Turtle
UP = 90
DOWN = 270
MOVE_DISTANCE = 25


class Paddle(Turtle):
    def __init__(self,position):
      super().__init__()
      self.create_paddle(position)
      
      
    def create_paddle(self,position):
      
        self.shape("square")
        self.color("white")
        self.shapesize(stretch_wid=5,stretch_len=1)
        self.penup()
        self.goto(position)
    
    def up(self):
      new_y = self.ycor() + MOVE_DISTANCE
      self.goto(self.xcor(),new_y)
    def down(self):
      new_y = self.ycor() - MOVE_DISTANCE
      self.goto(self.xcor(),new_y)