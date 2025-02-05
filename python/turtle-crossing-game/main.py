import time
from turtle import Screen
from player import Player
from car_manager import CarManager
from scoreboard import Scoreboard

screen = Screen()
screen.setup(width=600, height=600)
screen.tracer(0)

turtle = Player()
screen.onkey(turtle.move_up, "Up")
screen.listen()
car_manager = CarManager()
game_is_on = True
scoreboard = Scoreboard()

while game_is_on: 
    time.sleep(0.1)
    screen.update()
    car = car_manager.generate_new_car()
    car_manager.move()
    
    for car in car_manager.all_cars:
        if turtle.distance(car) <  20:
            scoreboard.game_over()
            game_is_on = False
    
    if turtle.is_at_finish_line():
        turtle.go_to_start_line()
        car_manager.level_up()
        scoreboard.new_level()
        scoreboard.update_scoreboard()
    


    
screen.exitonclick()
