Find most efficient route using Djikstra algorithm
=======================

### Usage:

```shell
rake db:create && rake db:migrate
bundle exec rackup -p 8000
``` 

## Routes

The service can be tested by sending JSON requests to its endpoints (REST based).

### GET
#### "/get"
- Fetch map details by name
	http://localhost:8000/get?name=MAP+SP


#### "/best_route"
- Send map name, vehicle autonomy (km per liter), fuel cost per liter, departure point and arrival.
	http://localhost:8000/best_route
---

##### RESPONSE
```json
{
    "name" : "MAPA SP",
    "fuelCostPerLiter" : 2.5,
	"vehicleAutonomyPerKilometer": 10,
	"origin" : "B",
	"destination": "E"
}
```


## POST
### "/map"
- Persist map to database
	http://localhost:8000/map/

### JSON map sample
 
```json
{
	"map" : 
	{
		"name" : "Mapa SP",
		"points" : [
			{
				"departure": "A", 
				"destination": "B",
				"distanceInKilometers": 10 
			},
			{
				"departure": "B",
				"destination": "D",
				"distanceInKilometers": 15 
			},
			{
				"departure": "A",
				"destination": "C",
				"distanceInKilometers": 20 
			},
			{
				"departure": "C",
				"destination": "D",
				"distanceInKilometers": 30 
			},
			{
				"departure": "B",
				"destination": "E",
				"distanceInKilometers": 50 
			},
			{
				"departure": "D",
				"destination": "E",
				"distanceInKilometers": 30 
			}
		]
	}
}
```

## DELETE

### "/map"
- Deletes existing map by name

