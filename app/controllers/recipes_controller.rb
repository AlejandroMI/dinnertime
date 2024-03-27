class RecipesController < ApplicationController
  def index
    # If there's a search query (ingredients), perform the search
    if params[:search].present?
      ingredient_names = params[:search].split(',').map(&:strip)
      @recipes = Recipe.search_by_ingredient(ingredient_names)
    else
      @recipes = Recipe.order("RANDOM()").limit(10)
    end
  end
end
