# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApplicationController
      def index
        render json: decorate_categories(TheMealDbService.categories)
      end

      private

      def decorate_categories(categories_as_json)
        categories = categories_as_json&.[]('categories') || []

        categories.map! do |category|
          {
            id: category['idCategory'],
            type: 'category',
            attributes: {
              name: category['strCategory'],
              description: category['strCategoryDescription']
            },
            links: {
              self: { href: "http://localhost:3000/api/v1/categories/#{category['idCategory']}" },
              recipes: { href: "http://localhost:3000/api/v1/categories/#{category['idCategory']}/recipes" },
              thumbnail: { href: category['strCategoryThumb'] }
            }
          }
        end

        {
          data: categories,
          links: { self: { href: 'http://localhost:3000/api/v1/categories' } }
        }
      end
    end
  end
end
