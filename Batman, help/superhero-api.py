import requests
import json

token = 3555165407858566

url = "https://superheroapi.com/api/" + str(token)

ids = [70, 60, 63, 561, 491, 558, 678, 522, 514, 370, 309, 165]

for id in ids:
    urlRequest = url + "/" + str(id)
    print("Requesting", urlRequest)
    resp = requests.get(url=urlRequest)
    data = resp.json()
    print(data)

    with open(str(id) + ".txt", 'w') as outfile:
        json.dump(data, outfile, indent=4)
