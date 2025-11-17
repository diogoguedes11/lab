import art
import menu
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
