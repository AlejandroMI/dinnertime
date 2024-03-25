require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  def setup
    @recipe = recipes(:chocolate_cake) # Assuming you have fixtures
  end

  test "should be valid" do
    assert @recipe.valid?
  end

  test "title should be present" do
    @recipe.title = "  "
    assert_not @recipe.valid?
  end

  test "cook_time should be non-negative" do
    @recipe.cook_time = -1
    assert_not @recipe.valid?
  end

  test "prep_time should be non-negative" do
    @recipe.prep_time = -1
    assert_not @recipe.valid?
  end

  test "should find recipes by ingredient name" do
    ingredient = ingredients(:flour)
    recipe_with_flour = recipes(:golden_cornbread)
    another_recipe_with_flour = recipes(:chocolate_cake)

    found_recipes = Recipe.search_by_ingredient(ingredient.name)

    # It should find both recipes that contain flour
    assert_includes found_recipes, recipe_with_flour, "Should find recipes containing flour"
    assert_includes found_recipes, another_recipe_with_flour, "Should find recipes containing flour"
  end
end
