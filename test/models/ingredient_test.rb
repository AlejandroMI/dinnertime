require "test_helper"

class IngredientTest < ActiveSupport::TestCase
  def setup
    @ingredient = ingredients(:flour)
  end

  test "should be valid" do
    assert @ingredient.valid?
  end

  test "name should be present" do
    @ingredient.name = "  "
    assert_not @ingredient.valid?
  end

  test "name should be unique" do
    duplicate_ingredient = @ingredient.dup
    @ingredient.save
    assert_not duplicate_ingredient.valid?
  end
end
