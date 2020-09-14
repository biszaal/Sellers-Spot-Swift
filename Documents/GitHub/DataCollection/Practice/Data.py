import matplotlib.pyplot as plt

unit = "http://api.worldbank.org/countries"
filters = "?per_page=31&incomeLevel=LIC"
query = unit + filters

print(query)

import requests
webpage = requests.get(query)

import xmltodict

UNITS = xmltodict.parse(webpage.content)


UNITS.keys()

type(UNITS['wb:countries'])

UNITS['wb:countries'].keys()

UNITS['wb:countries']['@page']
UNITS['wb:countries']['@pages']
UNITS['wb:countries']['@per_page']
UNITS['wb:countries']['@total']

type(UNITS['wb:countries']['wb:country'])

UNITS['wb:countries']['wb:country'][0]

type(UNITS['wb:countries']['wb:country'][0])

UNITS['wb:countries']['wb:country'][0].keys()

UNITS['wb:countries']['wb:country'][0]['wb:name']

UNITS['wb:countries']['wb:country'][0]['wb:region']

allUnits = UNITS['wb:countries']['wb:country']
names = []
regions = []

for unit in allUnits:
  names.append(unit['wb:name'])
  regions.append(unit['wb:region'])

names = [unit['wb:name'] for unit in allUnits]
regions = [unit['wb:region'] for unit in allUnits]

import pandas
columnsAsDict = {'NAME':names, 'REGION':regions}
lowIncomeCountries = pandas.DataFrame.from_dict(columnsAsDict)

print(lowIncomeCountries)

print(UNITS)