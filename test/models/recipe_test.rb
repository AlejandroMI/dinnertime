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
end
