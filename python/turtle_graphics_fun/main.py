import turtle as t
import random as r
timmy = t.Turtle()

colors = ["pale turquoise","cyan","navy","light gray","medium sea green"]
timmy.shape("turtle")


def draw_shape(num_sides):
  for _ in range(num_sides):
    angle = 360 / num_sides
    timmy.forward(100)
    timmy.right(angle)


for shape_size in range(3,11):
  timmy.color(r.choice(colors))
  draw_shape(shape_size)


screen = t.Screen()

screen.exitonclick()