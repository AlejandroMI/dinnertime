class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  validates :title, presence: true
  validates :cook_time, :prep_time, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  # We can add more validations here...

  def self.search_by_ingredient(ingredient_names)
    # Allow for a single ingredient (string) or an array of ingredients
    ingredient_names = [ingredient_names].flatten.map(&:downcase)

    joins(:ingredients)
      .where("LOWER(ingredients.name) % ANY (ARRAY[?])", ingredient_names)
      .distinct # This is to avoid repeating the same recipe if it has multiple ingredients in the search query
  end
end
