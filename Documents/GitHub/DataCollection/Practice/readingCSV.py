import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import style
import csv

style.use('fivethirtyeight')

expenses = pd.read_csv('expenses.csv', index_col = 2)

results = []
with open("input.csv") as csvfile:
    reader = csv.reader(csvfile, quoting=csv.QUOTE_NONNUMERIC) # change contents to floats
    for row in reader: # each row is a list
        results.append(row)

ar = []
df = expenses.head(35)

for i in range (0,35):
    ar.append(i, df)

print (ar)
# sd = df.reindex(columns=['01-Apr'])
# column = [0, 1, 3]
# for row in expenses:
#     content = list(row[i] for i in column)
#     print (content)
#

# db = sd.diff(axis = 1)
#
# db.plot(kind = 'bar')
#
# print(df)

# plt.show()
