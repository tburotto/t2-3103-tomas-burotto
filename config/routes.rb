Rails.application.routes.draw do
  resources :hamburguesa
  resources :ingrediente
  put 'hamburguesa/:id_hamburguesa/ingrediente/:id_ingrediente' => 'hamburguesa#editingrediente'
end
