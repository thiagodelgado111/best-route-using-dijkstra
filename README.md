
Rota mais eficiente baseando-se em malhas logísticas
=======================

### Motivação

Tecnologias utilizadas:
- SQLite
- Bundler
- ActiveRecord
- PriorityQueue
- Sinatra


As tecnologias escolhidas permitem que a aplicação seja criada rapidamente, tendo em vista que provê a infraestrutura necessária para a criação de um serviço "REST" em pouquissimo tempo. 

A título de simplicidade, optei por utilizar sqlite3 com a implementação de ActiveRecord já muito conhecida - utilizada em produção em vários ambientes - para cuidar da persistência dos dados. Para determinar a rota menos custosa, escolhi o algoritmo de Dijkstra com uma Fibonnaci-Heap visando a rapidez na busca e na remoção dos items da fila. 

Nesse post no stackoverflow tem uma discussão completa sobre o assunto da performance:
[http://stackoverflow.com/questions/21065855/the-big-o-on-the-dijkstra-fibonacci-heap-solution]


### Como usar:
Pra fazer o deploy, basta executar os passos abaixo:

```shell
rake db:create && rake db:migrate
bundle exec rackup -p 8000
``` 


### Rotas

O serviço pode ser testado utilizando-se um client REST, aceita requisições JSON.

#### GET
"/get"
- Obter detalhes do mapa, utilizando o parâmetro "name"
	http://localhost:8000/get?name=MAPA SP

#### POST
"/map"
- Enviar json com dados do mapa e dos pontos da malha para persistir na base de dados
	http://localhost:8000/map/

JSON - Malha logística para criar/atualizar o mapa
 
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



"/best_route"
- Enviar o nome do mapa, autonomia do veículo, custo por litro de combustível, origem e destino
	http://localhost:8000/best_route


```json
{
    "name" : "MAPA SP",
    "fuelCostPerLiter" : 2.5,
	"vehicleAutonomyPerKilometer": 10,
	"origin" : "B",
	"destination": "E"
}
```


#### DELETE
"/map"
- Deleta o mapa existente, basta passar o nome do mapa como parâmetro
	http://localhost:8000/map/