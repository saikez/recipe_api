# frozen_string_literal: true

# Gets json from The Meal DB and returns it in a cleaner modern format
class TheMealDbService
  BASE_URL = "https://www.themealdb.com/api/json/v1/#{Rails.application.credentials[:THE_MEAL_DB_API_KEY]}".freeze

  def self.categories
    HTTParty.get("#{BASE_URL}/categories.php")
  end

  def self.recipes(category_id)
    category_name = categories&.[]('categories')&.find { |c| c['idCategory'] == category_id.to_s }
    return [] unless category_name

    HTTParty.get("#{BASE_URL}/filter.php", query: { c: category_name['strCategory'] })
  end

  def self.recipe(recipe_id)
    HTTParty.get("#{BASE_URL}/lookup.php", query: { i: recipe_id })
  end
end
