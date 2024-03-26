class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  validates :title, presence: true
  validates :cook_time, :prep_time, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  # We can add more validations here...

  def self.search_by_ingredient(ingredient_names)
    ingredient_names = [ingredient_names].flatten.map(&:downcase)

    conditions = ingredient_names.map { |name| "LOWER(ingredients.name) LIKE ?" }.join(' OR ')
    query_params = ingredient_names.map { |name| "%#{name}%" }

    recipes = joins(:ingredients).where(conditions, *query_params)

    if ingredient_names.length > 1
      grouped_recipes = recipes.to_a.group_by(&:id).map do |_, recipes|
        [recipes.first, recipes.count]
      end

      sorted_and_grouped_recipes = grouped_recipes.sort_by { |_, count| -count }

      unique_sorted_recipes = sorted_and_grouped_recipes.map { |recipe, _| recipe }

      return unique_sorted_recipes
    else
      return recipes.distinct
    end
  end
end
