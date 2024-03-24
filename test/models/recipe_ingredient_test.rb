require "test_helper"

class RecipeIngredientTest < ActiveSupport::TestCase
  def setup
    @recipe = recipes(:golden_cornbread)
    @ingredient = ingredients(:flour)
    @recipe_ingredient = RecipeIngredient.new(recipe: @recipe, ingredient: @ingredient)
  end

  test "should be valid" do
    assert @recipe_ingredient.valid?
  end

  test "should require a recipe_id" do
    @recipe_ingredient.recipe_id = nil
    assert_not @recipe_ingredient.valid?
  end

  test "should require an ingredient_id" do
    @recipe_ingredient.ingredient_id = nil
    assert_not @recipe_ingredient.valid?
  end
end
