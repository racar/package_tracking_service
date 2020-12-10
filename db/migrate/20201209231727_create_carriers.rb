class CreateCarriers < ActiveRecord::Migration[6.0]
  def change
    create_table :carriers do |t|
      t.string :status
      t.string :track_id

      t.timestamps
    end
  end
end
