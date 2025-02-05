STARTING_POSITION = (0, -280)
MOVE_DISTANCE = 10
FINISH_LINE_Y = 280
from turtle import Turtle

class Player(Turtle):
    def __init__(self):
        super().__init__()
        self.shape("turtle")
        self.color("black")
        self.start_pos()
    def start_pos(self):
        self.penup()
        self.goto(STARTING_POSITION)
        self.left(90)
        
    def move_up(self):
        self.forward(MOVE_DISTANCE)

    def is_at_finish_line(self):
        if self.ycor() > FINISH_LINE_Y:
            return True
        else: 
            return False
    def go_to_start_line(self):
        self.goto(STARTING_POSITION)