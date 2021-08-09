class CreateSeats < ActiveRecord::Migration[5.2]
  def change
    create_table :seats do |t|

      t.timestamps
    end
  end
end
