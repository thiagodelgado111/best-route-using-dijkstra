require File.expand_path '../spec_helper.rb', __FILE__

describe Map do

	it "returns a map named TEST" do
		map = Map.find_by(name: 'TEST')
		expect(map).should be
	end

end