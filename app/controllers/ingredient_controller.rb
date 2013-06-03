
class IngredientController

  attr_reader :params

  def initialize(ingredient_params)
    @params = ingredient_params
  end

  def create
    ingredient = Ingredient.new params[:ingredient]
    Helper.creation_success_message ingredient
  end

  def list_ingredients
    ingredients = Ingredient.all

    ingredients.each_with_index do | ingredient, i |
      render_line_item ingredient, i
    end
  end

  def render_line_item(ingredient, i)
    puts "\n" if i == 0
    list_num = (i + 1) < 10 ? " #{i + 1}" : "#{i + 1}"
    ingredient_name = "#{list_num}. #{ingredient.name.titleize}:"

    case ingredient.description
    when nil then puts "#{list_num}. #{ingredient.name.titleize}"
    else puts ingredient_name.ljust(26) + "#{ingredient.description}"
    end
  end

  def delete
    ingredient_match = Ingredient.where(name: params[:ingredient][:name]).first
    check_if_name_matches_ingredient ingredient_match
    ingr_array = RecipeIngredient.where(ingredient_id: ingredient_match.id).all
    ingr_array.each do | recipe_ingredient |
      recipe_ingredient.destroy
    end
    ingredient_match.destroy
    Helper.matching_record_destroyed_message ingredient_match
  end

  def check_if_name_matches_ingredient(ingredient_match)
    if ingredient_match.nil?
      puts "\n#{params[:recipe][:name].titleize} is an invalid ingredient name."
      puts 'To view a list of possible ingredients, type ruby sb ingredients'
      exit
    end
  end

end