import requests

file = 'http://api.openweathermap.org/data/2.5/weather?q=Tokyo,Japan&units=imperial&APPID=3f5a0660a8fe70340eaa464fa05237cb'

webpage = requests.get(file)

code = webpage.json()

print(code)

if type(code) is dict:
    print(code.keys())
    x = input("Choose one from above: ")

    option1 = code[x].keys()

if type(option1) is dict:
    y = input("Choose one from above: ")

    option2 = code[x][y]

if type(option2) is dict:
    z = input("Choose one from above: ")

    option3 = code[x][y][z]
