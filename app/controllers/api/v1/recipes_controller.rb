# frozen_string_literal: true

module Api
  module V1
    class RecipesController < ApplicationController
      def index
        render json: decorate_recipes(TheMealDbService.recipes(params[:category_id]))
      end

      def show
        render json: decorate_recipe(TheMealDbService.recipe(params[:id]))
      end

      private

      def decorate_recipes(recipes_as_json)
        recipes = recipes_as_json&.[]('meals') || []

        recipes.map do |recipe|
          {
            id: recipe['idMeal'],
            type: 'recipe',
            attributes: {
              name: recipe['strMeal'],
              thumbnail: recipe['strMealThumb']
            },
            links: {
              self: { href: "http://localhost:3000/categories/#{params[:category_id]}/recipe/#{recipe['idMeal']}" },
              category: { href: "http://localhost:3000/categories/#{params[:category_id]}" }
            }
          }
        end

        {
          data: recipes,
          links: { self: { href: "http://localhost:3000/api/v1/categories/#{params[:category_id]}/recipes" } }
        }
      end

      def decorate_recipe(recipe_as_json)
        recipe = recipe_as_json&.[]('meals')&.first

        if recipe
          decorated_recipe = {
            id: recipe['idMeal'],
            type: 'recipe',
            attributes: {
              name: recipe['strMeal'],
              category: recipe['strCategory'],
              area: recipe['strArea'],
              instructions: recipe['strInstructions'],
              tags: recipe['strTags'].split(','),
              ingredients: get_ingredients(recipe),
              dateModified: recipe['strDateModified']
            },
            links: {
              self: { href: "http://localhost:3000/categories/#{params[:category_id]}/recipe/#{params[:id]}" },
              category: { href: "http://localhost:3000/categories/#{params[:category_id]}" },
              thumbnail: { href: recipe['strMealThumb'] },
              imageSource: { href: recipe['strImageSource'] },
              source: { href: recipe['strSource'] },
              youtube: { href: recipe['youtube'] }
            }
          }
        else
          decorated_recipe = {}
        end

        {
          data: decorated_recipe,
          links: {
            self: { href: "http://localhost:3000/api/v1/categories/#{params[:category_id]}/recipe/#{params[:id]}" }
          }
        }
      end

      def get_ingredients(recipe)
        ingredients = recipe.select { |key, value| key =~ /strIngredient/ && value.present? }
        ingredients.map do |key, value|
          ingredient_number = key.to_s.delete('^0-9') # fast method of extracting INDEX from "strIngredientINDEX"
          {
            ingredient: value,
            measure: recipe["strMeasure#{ingredient_number}"]
          }
        end
      end
    end
  end
end
