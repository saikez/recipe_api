require 'swagger_helper'

RSpec.describe 'api/v1/recipes', type: :request do
  path '/api/v1/categories/{category_id}/recipes' do
    parameter name: 'category_id', in: :path, type: :string, description: 'category_id'

    get('list recipes') do
      response(200, 'successful') do
        let(:category_id) { '3' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/recipes/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show recipe') do
      response(200, 'successful') do
        let(:id) { '52812' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
