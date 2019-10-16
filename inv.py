#!/usr/bin/env python3

cities = { 
            "New York": { "Street": "Roadstreet", "Number": 20 },
            "Las Vegas": { "Street": "TreeStreet", "Number": 455 }    
         }

for city in cities:
    print(str(city) + ": " + str(cities[city]["Street"])
    + " " + str(cities[city]["Number"])) 