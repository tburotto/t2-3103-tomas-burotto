class CreateIngredientes < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredientes do |t|
      t.string :nombre
      t.string :descripcion

      t.timestamps
    end
    create_table :hamburguesas_ingredientes do |t|
      t.belongs_to :hamburguesas
      t.belongs_to :ingredientes
    end
  end
end
