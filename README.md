
LEVAETRAZ
=======================

- SQLite
- Dijkstra para calcular qual é a melhor rota
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


## Detalhes

Esse protótipo foi criado usando 'sinatra' por ser um componente leve e de fácil instalação, existem duas rotas, /map utilizando POST para criar o mapa e /map passando o nome do mapa como parametro "name" utilizando DELETE para deletar o mapa anterior. 

A título de simplicidade, optei por utilizar sqlite3 com activerecord para fazer a persistência dos dados. Para determinar a rota menos custosa, escolhi o algoritmo de Dijkstra com uma Fibonnaci-Heap visando a rapidez na busca pela rota menos custosa. 

Nesse post no stackoverflow tem uma discussão completa sobre o assunto da performance:
http://stackoverflow.com/questions/21065855/the-big-o-on-the-dijkstra-fibonacci-heap-solution

Basicamente, o tempo gasto ao achar um mínimo dentro da pilha é O(1), fora isso, temos a operação de remoção do nó da pilha.


O serviço pode ser testado um client REST por exemplo, aceita requisições JSON no modelo acima. Eu gosto da idéia de manter a API isolada como se fosse uma mera casca que centralizaria outros serviços. Como uma espécie de gateway/proxy unindo vários serviços. A idéia de construir algo usando o sinatra também permite que o cliente ou a interface que vai consumir esse serviço possa ser desenvolvido(a) em paralelo.



Para por o serviço no ar, é preciso basicamente:
- rake db:create && rake db:migrate
- ruby app.rb &
- 

## Roadmap
- RabbitMQ ou DelayedJob para processamento em background
- Versionamento da API
- Cache das requisições
- MongoDB para represar as requisições externas e posteriomente extrair e consolidar/replicar esses dados
