class AddTypeToCarrier < ActiveRecord::Migration[6.0]
  def change
    add_column :carriers, :type, :string
  end
end
