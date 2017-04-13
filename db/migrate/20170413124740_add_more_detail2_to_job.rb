class AddMoreDetail2ToJob < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :location, :string
    add_column :jobs, :company, :string
    add_column :jobs, :number, :integer
  end
end
