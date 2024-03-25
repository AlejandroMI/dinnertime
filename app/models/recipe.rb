class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  validates :title, presence: true
  validates :cook_time, :prep_time, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  # We can add more validations here...

  def self.search_by_ingredient(ingredient_name)
    joins(:ingredients).where(ingredients: { name: ingredient_name })
  end
end
