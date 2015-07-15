
LEVAETRAZ
=======================

- RabbitMQ ou DelayedJob para processamento em background
- SQLite
- Dijkstra
- Sinatra


# Parâmetros de entrada (JSON)

## Malha logística

```json
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
```

## Menor valor de entrega e melhor caminho (VRP)

- Parâmetros de entrada para se calcular qual é a melhor rota
  * Malha logística
  * Nome do ponto de origem da jornada
  * Nome do ponto de destino final da jornada
  * Autonomia do caminhão (Km/L)
  * $ Valor do litro de combustível


  Exemplo de entrada: 
 
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
	},
	"fuelCostPerLiter" : 2.5,
	"vehicleAutonomyPerKilometer": 10,
	"origin" : "A",
	"destination": "D"
}
```
