import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import style
import csv
import re

style.use('fivethirtyeight')

expenses = pd.read_csv('expenses.csv')

#print(expenses)

file = open('expenses.csv', 'r')

for line in file:
    i = 0
    price = re.findall(r"[0-9]{0,9}¥", line)
    priceNum = re.findall(r"[0-9]{0,9}", price)
    print(priceNum)