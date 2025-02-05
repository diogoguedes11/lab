import art
MENU = {
    "espresso": {
        "ingredients": {
            "water": 50,
            "coffee": 18,
        },
        "cost": 1.5,
    },
    "latte": {
        "ingredients": {
            "water": 200,
            "milk": 150,
            "coffee": 24,
        },
        "cost": 2.5,
    },
    "cappuccino": {
        "ingredients": {
            "water": 250,
            "milk": 100,
            "coffee": 24,
        },
        "cost": 3.0,
    }
}
resources = {
    "water": 300,
    "milk": 200,
    "coffee": 100,
}

print(art.logo)
def insert_coins():
    print("Please insert coins. ")
    quarters = input("how many quarters: ")
    dimes = input("how many dimes: ")
    nickles = input("how many nickles: ")
    pennies = input("how many pennies:")


turn_on_machine = True
while turn_on_machine:
    request = input("What would you like? (expresso,latte,cappucino): ")
