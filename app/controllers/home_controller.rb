class HomeController < ApplicationController
  def index
    recipes = Recipe.where(published: true)
    recipes_for_display = recipes.last(7)

    @latest_recipe = recipes_for_display[6]
    @latest_recipe_excerpt = MarkdownConverter.convert(@latest_recipe.excerpt)
    @next_two_latest_recipes = recipes_for_display[4..5]
    @recent_recipes = recipes_for_display[0..3]
  end

  def about
  end

  def recipe_index
    @recipes = Recipe.where(published: true).order(title: :asc)
  end

  def photos
  end
end
