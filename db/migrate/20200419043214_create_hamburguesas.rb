class CreateHamburguesas < ActiveRecord::Migration[6.0]
  def change
    create_table :hamburguesas do |t|
      t.string :nombre
      t.integer :precio
      t.string :descripcion
      t.string :imagen

      t.timestamps
    end
  end
end
