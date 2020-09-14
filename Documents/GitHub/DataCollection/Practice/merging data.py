import pandas as pd

# df1 = pd.DataFrame({'Int_rate' : [2, 1, 2, 3], 'IND_GDP' : [50, 45, 45, 67]},
#                    index = [2001, 2002, 2003, 2004])
#
# df2 = pd.DataFrame({'Low_Teir_HPI' : [50, 45, 45, 67], 'Unimployment' : [1, 3, 5, 6]},
#                    index = [2001, 2003, 2004, 2004])
#
# joined = df1.join(df2)
# print(joined)

expenses = pd.read_csv("expenses.csv")

expenses.to_html('expenses.html')

htmTable = expenses.to_html()

print(htmTable)