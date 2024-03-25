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

  test "should find recipes by multiple ingredient names" do
    ingredient_one = ingredients(:cocoa_powder)
    ingredient_two = ingredients(:magic)
    recipe_with_cocoa = recipes(:chocolate_cake) # Fixture with cocoa
    recipe_with_magic = recipes(:magic_pizza) # Fixture with magic

    found_recipes = Recipe.search_by_ingredient([ingredient_one.name, ingredient_two.name])

    assert_includes found_recipes, recipe_with_cocoa, "Should find recipes containing flour"
    assert_includes found_recipes, recipe_with_magic, "Should find recipes containing milk"
  end

  test "should find recipes that have multiple ingredients searched without repeating them" do
    ingredient_one = ingredients(:cocoa_powder)
    ingredient_two = ingredients(:milk)
    recipe_with_cocoa_and_milk = recipes(:chocolate_cake) # Fixture with cocoa

    found_recipes = Recipe.search_by_ingredient([ingredient_one.name, ingredient_two.name])

    # It should only find the recipe that contains both cocoa and milk, the chocolate cake, and just once
    assert_equal 1, found_recipes.count
    assert_includes found_recipes, recipe_with_cocoa_and_milk, "Should find recipes containing flour"
  end

  test "should find recipes only one even if you repeat the ingredient" do
    ingredient_one = ingredients(:cocoa_powder)
    recipe_with_cocoa_and_milk = recipes(:chocolate_cake) # Fixture with cocoa

    found_recipes = Recipe.search_by_ingredient([ingredient_one.name, ingredient_one.name])

    # It should only find the recipe that contains both cocoa and milk, the chocolate cake, and just once
    assert_equal 1, found_recipes.count
    assert_includes found_recipes, recipe_with_cocoa_and_milk, "Should find recipes containing flour"
  end

  test "should find recipes by ingredient name case-insensitive" do
    ingredient = ingredients(:flour)
    recipe_with_flour = recipes(:golden_cornbread)
    another_recipe_with_flour = recipes(:chocolate_cake)

    found_recipes = Recipe.search_by_ingredient(ingredient.name.upcase)

    # It should find both recipes that contain flour
    assert_includes found_recipes, recipe_with_flour, "Should find recipes containing flour"
    assert_includes found_recipes, another_recipe_with_flour, "Should find recipes containing flour"
  end
end
