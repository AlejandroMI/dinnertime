class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  validates :title, presence: true
  validates :cook_time, :prep_time, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  # We can add more validations here...

  def self.search_by_ingredient(ingredient_names)
    ingredient_names = [ingredient_names].flatten.map(&:downcase)

    conditions = ingredient_names.map { |name| "LOWER(ingredients.name) LIKE ?" }.join(' OR ')
    query_params = ingredient_names.map { |name| "% #{name}%" }

    recipes = joins(:ingredients)
                .where(conditions, *query_params)
                .preload(:ingredients)
                .distinct

    # Sorting by relevance
    # Collect the necessary data for sorting
    grouped_recipes = recipes.map do |recipe|
      match_count = recipe.count_ingredient_matches(ingredient_names)
      total_ingredients_count = recipe.ingredients.size
      [recipe, match_count, total_ingredients_count]
    end
    # Ensuring recipes with more matches come first, then among those, recipes with fewer total ingredients come first
    sorted_recipes = grouped_recipes.sort_by { |_, match_count, total_ingredients_count| [-match_count, total_ingredients_count] }
    # Extract recipes from the sorted array
    unique_sorted_recipes = sorted_recipes.map(&:first)

    # TODO: Just return first 20 recipes, we can add pagination later
    return unique_sorted_recipes.first(20)
  end

  # Counts the number of ingredients in the recipe that match the given ingredient names but only once per ingredient.
  # @param ingredient_names [Array<String>] the names of the ingredients to match
  # @return [Integer] the number of ingredients that match the given names
  def count_ingredient_matches(ingredient_names)
    # Get the ingredients from recipe and flatten them as a string to see if it includes the passed names
    recipe_ingredients = self.ingredients.map(&:name).join(" ").downcase

    # Count the number of ingredients that match the given names
    ingredient_names.count do |ingredient_name|
      recipe_ingredients.include?(ingredient_name)
    end
  end

end
