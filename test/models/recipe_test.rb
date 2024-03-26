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
    recipe_with_flour = recipes(:golden_cornbread)
    another_recipe_with_flour = recipes(:chocolate_cake)

    found_recipes = Recipe.search_by_ingredient("flour")

    # It should find both recipes that contain flour
    assert_includes found_recipes, recipe_with_flour, "Should find first recipe containing flour"
    assert_includes found_recipes, another_recipe_with_flour, "Should find second recipe containing flour"
  end

  test "should find recipes by multiple ingredient names (2)" do
    recipe_with_cocoa = recipes(:chocolate_cake) # Fixture with cocoa
    recipe_with_magic = recipes(:magic_pizza) # Fixture with magic

    found_recipes = Recipe.search_by_ingredient(["cocoa powder", "magic"])

    assert_includes found_recipes, recipe_with_cocoa, "Should find recipes containing cocoa powder"
    assert_includes found_recipes, recipe_with_magic, "Should find recipes containing magic"
  end

  test "should find recipes by multiple ingredient names (3)" do
    recipe_with_flour = recipes(:bread)
    another_recipe_with_flour = recipes(:golden_cornbread)
    yet_another_recipe_with_flour = recipes(:chocolate_cake)

    found_recipes = Recipe.search_by_ingredient(["flour", "water", "salt"])

    # It should order the recipes prioritizing the one with more ingredient matches
    assert_equal 3, found_recipes.count
    assert_includes found_recipes, recipe_with_flour
    assert_includes found_recipes, another_recipe_with_flour
    assert_includes found_recipes, yet_another_recipe_with_flour
  end

  test "should find recipes that have multiple ingredients searched without repeating them" do
    recipe_with_cocoa_and_milk = recipes(:chocolate_cake) # Fixture with cocoa

    found_recipes = Recipe.search_by_ingredient(["cocoa powder", "milk"])

    # It should only find the recipe that contains both cocoa and milk, the chocolate cake, and just once
    assert_equal 1, found_recipes.count
    assert_includes found_recipes, recipe_with_cocoa_and_milk, "Should find recipes containing cocoa and milk"
  end

  test "should find recipes only one even if you repeat the ingredient" do
    recipe_with_cocoa_and_milk = recipes(:chocolate_cake) # Fixture with cocoa

    found_recipes = Recipe.search_by_ingredient(["cocoa powder", "cocoa powder"])

    # It should only find the recipe that contains both cocoa and milk, the chocolate cake, and just once
    assert_equal 1, found_recipes.count
    assert_includes found_recipes, recipe_with_cocoa_and_milk, "Should find recipes containing flour"
  end

  test "should find recipes by ingredient name case-insensitive" do
    recipe_with_flour = recipes(:golden_cornbread)

    found_recipes = Recipe.search_by_ingredient('FLOUR')

    # It should find both recipes that contain flour
    assert_includes found_recipes, recipe_with_flour, "Should find recipes containing flour"
  end

  test "should find recipes by partial ingredient name" do
    recipe_with_cocoa = recipes(:chocolate_cake) # Fixture with cocoa powder

    found_recipes = Recipe.search_by_ingredient("cocoa") # Searching just for cocoa

    assert_includes found_recipes, recipe_with_cocoa, "Should find recipes containing cocoa powder"
  end

  test "should order recipes prioritizing the ones with more ingredient matches" do
    recipe_with_flour = recipes(:bread) # 3 matches
    another_recipe_with_flour = recipes(:golden_cornbread) # 2 matches
    yet_another_recipe_with_flour = recipes(:chocolate_cake) # 1 match

    found_recipes = Recipe.search_by_ingredient(["flour", "water", "salt"])

    # It should order the recipes prioritizing the one with more ingredient matches
    assert_equal 3, found_recipes.count
    assert_equal recipe_with_flour, found_recipes.first
    assert_equal another_recipe_with_flour, found_recipes.second
    assert_equal yet_another_recipe_with_flour, found_recipes.last
  end
end
