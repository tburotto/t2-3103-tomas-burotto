class CreateIngredientes < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredientes do |t|
      t.string :nombre
      t.string :descripcion

      t.timestamps
    end
    create_join_table :hamburguesas, :ingredientes do |t|
    end
  end
end
