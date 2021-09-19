Rails.application.routes.draw do
  resources :asignatura_masters
  resources :masters
  get 'admin/index'
  devise_for :users
  resources :asignaturas
  resources :grados
  resources :universidads
  resources :comunidads
  root 'static_pages#index'
  get 'static_pages/index'
  get 'static_pages/buscadorG'
  get 'static_pages/buscadorM'
  get 'static_pages/buscadorMaster'
  get 'static_pages/buscadorGrado'

  get '/universidads/scrapeMaster/:idUniversidad', to: "universidads#scrapeMaster" , as: "universidads_scrapeMaster"
  
  get '/universidads/scrape/:idUniversidad', to: "universidads#scrape" , as: "universidads_scrape"
  get '/grados/borrar_grados/:idUniversidad', to: "grados#borrar_grados" , as: "grados_borrar"
  get '/masters/borrar_masters/:idUniversidad', to: "masters#borrar_masters" , as: "borrar_masters"
  get '/universidads/scrapear_comunidad/:idComunidad', to: "universidads#scrapear_comunidad" , as: "scrapear_comunidad"
  get '/comunidads/borrar_grados_y_masteres_comunidad/:idComunidad', to: "comunidads#borrar_grados_y_masteres" , as: "borrar_grados_y_masteres_comunidad"
end
