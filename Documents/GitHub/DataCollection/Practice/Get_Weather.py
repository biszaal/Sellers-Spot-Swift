import requests


str_country = input("Enter the name of a Country: ")
str_city = input("Enter the name of a City: ")
str_API = '3f5a0660a8fe70340eaa464fa05237cb'
float_version = 2.5

#file = 'http://api.openweathermap.org/data/2.5/weather?q=Tokyo,Japan&units=imperial&APPID=3f5a0660a8fe70340eaa464fa05237cb'

file = 'http://api.openweathermap.org/data/'+ str(float_version) + '/weather?q=' + str_city + ',' + str_country + '&units=imperial&APPID=' + str_API

webpage = requests.get(file)

code = webpage.json()

#converting Celsius to Fehrenheit
def fehToCel (int_tempreture):
      int_cel = (int_tempreture - 32) * (5 / 9)
      return round(int_cel)

print(code)

if code['main'] :
      print(true)

str_weatherDis = code['weather'][0]['description']
int_temp = code['main']['temp']
int_highTemp = code['main']['temp_max']
int_lowTemp = code['main']['temp_min']
int_humidity = code['main']['humidity']

print("The weather of", str_country + ",", str_city, "is", fehToCel(int_temp), "degree Celsius with", str_weatherDis +
      ". The high of today is", fehToCel(int_highTemp), "degree Celsius and low is", fehToCel(int_lowTemp),
      "degree Celsius. The humidity level is", int_humidity, "percent.")



