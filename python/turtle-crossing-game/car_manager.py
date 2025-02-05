from turtle import Turtle
import random

COLORS = ["red", "orange", "yellow", "green", "blue", "purple"]
STARTING_MOVE_DISTANCE = 10
MOVE_INCREMENT = 5

class CarManager:
    def __init__(self):
        self.all_cars = []
        self.generate_new_car()
        self.car_speed = STARTING_MOVE_DISTANCE

    def generate_new_car(self):
        random_chance = random.randint(1,3)
        if random_chance == 1:
            car = Turtle()
            car.shape("square")
            car.shapesize(1,2)
            car.color(random.choice(COLORS))
            car.penup()
            car.goto(300, random.randint(-250, 250))
            self.all_cars.append(car)

    def move(self):
        for car in self.all_cars:
            car.backward(self.car_speed)
            # Check if the car has moved off the screen
        
    def level_up(self):
        self.car_speed += MOVE_INCREMENT