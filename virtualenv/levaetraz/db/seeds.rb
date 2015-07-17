
map = Map.create(:name=>"TEST")

5.times { |i|
	Node.create(:departure=>"A#{i}", :map => map, :destination => "B#{i}", :distanceInKilometer=> 10.5)
}