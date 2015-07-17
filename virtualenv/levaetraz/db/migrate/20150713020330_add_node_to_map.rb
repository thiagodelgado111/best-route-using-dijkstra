class AddNodeToMap < ActiveRecord::Migration
  def change
  	add_reference :nodes, :map, index: true, foreign_key: true
  end
end
