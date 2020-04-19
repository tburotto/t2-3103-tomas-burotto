Rails.application.routes.draw do
  resources :hamburguesa
  resources :ingrediente
  put 'hamburguesa/:id_hamburguesa/ingrediente/:id_ingrediente' => 'hamburguesa#edit_ingrediente'
  delete 'hamburguesa/:id_hamburguesa/ingrediente/:id_ingrediente' => 'hamburguesa#delete_ingrediente'
end
