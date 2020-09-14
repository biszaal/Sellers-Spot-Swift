import requests
from bs4 import BeautifulSoup

htmlFile = requests.get("http://worldpopulationreview.com/countries/" + "Japan".lower() + "-population/cities/").text

soup = BeautifulSoup(htmlFile, "html.parser")

tableData = []

tableRows = soup.find_all('tr')

for row in tableRows:
    tableCol = row.find_all('td')

    listData = []

    for col in tableCol:
        listData.append(col.text.strip())

    tableData.append(listData)

for i in range(1,len(tableData)):
	print(tableData[i][0])