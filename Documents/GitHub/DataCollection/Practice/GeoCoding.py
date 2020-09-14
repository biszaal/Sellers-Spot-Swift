
import requests



str_API = 'AIzaSyAtgV4jqBsFYjCP_peAA2sE3aIIZIOlJ44'
str_Location = input('Please enter the location: ')

str_Location = str_Location.replace(' ', '+')       #replacing space ' ' with plus '+' for it to work with html

file = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + str_Location + '&key=' + str_API

webpage = requests.get(file)

code = webpage.json()


double_lat = code["results"][0]["geometry"]["location"]["lat"]
double_lng = code["results"][0]["geometry"]["location"]["lng"]

str_city_name = code['results'][0]['address_components'][-2]['long_name']
str_country_name = code['results'][0]['address_components'][-1]['long_name']
print("Country =", str_country_name, "City =", str_city_name)
print(" The latitude of the location is", double_lat, "and the longitude is", double_lng)