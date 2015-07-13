require 'priority_queue'

class DijkstraGraph

	MAX_INT = (2 ** ((0.size * 8) - 2) - 1)

	def initialize()
		@nodes = {}
	end

	def add_node(key, children)
		@nodes[key] = children
	end

	def calculate_optimal_route(departure, destination)

		deltas = {}
		previous = {}
		vertices = PriorityQueue.new

		# initializing nodes
		@nodes.each do |vertex, value|
			if vertex == departure
				deltas[vertex] = 0
				vertices[vertex] = 0
			else
				deltas[vertex]= MAX_INT
				vertices[vertex] = MAX_INT				
			end
			previous[vertex] = nil
		end

		while vertices

			# get the closest node and remove it from the 'vertices' queue
			smallest = vertices.delete_min_return_key
			
			# if the smallest is equal to the destination node, wrap it up and return to the 
			if smallest == destination
				path = []

				while previous[smallest]
					path.push(smallest)
					smallest = previous[smallest]
				end

				path.push(departure)

				return path.reverse
			end

			if smallest == nil or deltas[smallest] == MAX_INT
				break
			end


			@nodes[smallest].each do |neighbor, value|

				# distance from the smallest node to this neighbor
				alt = deltas[smallest] + @nodes[smallest][neighbor]

				if alt < deltas[neighbor]

					# distance from node A to node B
					deltas[neighbor] = alt
					# tracking the heap of points
					previous[neighbor] = smallest
					vertices[neighbor] = alt
				end
			end
		end
	end

	def to_s
		return @nodes.inspect
	end
end

=begin

graph = DijkstraGraph.new
graph.add_node('A',{'B'=>10, 'C'=>20})
graph.add_node('B',{'D'=>15, 'E'=>50})
graph.add_node('C',{'D'=>30})
graph.add_node('D',{'E'=>30})
graph.add_node('E',{'B'=>50,'D'=>30})

puts graph.calculate_optimal_route('D','B')

=end