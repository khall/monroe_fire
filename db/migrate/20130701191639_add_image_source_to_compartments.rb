class AddImageSourceToCompartments < ActiveRecord::Migration
  def change
    add_column :compartments, :image_src, :string
  end
end
