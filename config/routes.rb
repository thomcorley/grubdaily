Rails.application.routes.draw do
  get 'tags/edit'

  get 'ingredient/index'

  get 'ingredient/create'

  get 'ingredient/show'

  get 'ingredient/new'

  get 'ingredient/update'

  get 'ingredient/delete'

  get 'recipe_imports/new' => 'recipe_imports#new'

  post 'recipe_imports/create' => 'recipe_imports#create'

  get 'recipe_imports/show' => 'recipe_imports#show'

  get 'generate_jekyll_post' => 'jekyll_posts#generate'

  get 'touch_ingredient_entry/:id', to: 'ingredient_entries#touch', as: 'touch_ingredient_entry'

  get 'new_recipe' => 'recipe_imports#new'

  resources :ingredient_entries
  resources :ingredient_sets
  resources :recipes
  resources :recipe_imports
  resources :tags
  resources :method_steps

  root :to => 'index#index'
end
