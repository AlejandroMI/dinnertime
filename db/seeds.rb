# There are more than 10.000 recipes in the JSON file, so it may take a while to seed the database.
# We can try to optimize the seeding process later by using the import method provided by the activerecord-import gem.
json_path = Rails.root.join('db', 'recipes-en.json')

recipes_data = JSON.parse(File.read(json_path))

recipes_data.each do |recipe_data|
  # to avoid creating duplicate records
  # ensures that the script can be run multiple times safely.
  recipe = Recipe.find_or_create_by!(title: recipe_data['title']) do |r|
    r.cook_time = recipe_data['cook_time']
    r.prep_time = recipe_data['prep_time']
    r.ratings = recipe_data['ratings']
    r.cuisine = recipe_data['cuisine']
    r.category = recipe_data['category']
    r.author = recipe_data['author']
    r.image = recipe_data['image']
  end

  recipe_data['ingredients'].each do |ingredient_name|
    ingredient = Ingredient.find_or_create_by!(name: ingredient_name)

    unless RecipeIngredient.exists?(recipe_id: recipe.id, ingredient_id: ingredient.id)
      RecipeIngredient.create!(recipe_id: recipe.id, ingredient_id: ingredient.id)
    end
  end
end

puts 'Recipes and ingredients seeded! 🌱'