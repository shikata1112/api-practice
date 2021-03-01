# frozen_string_literal: true

module Api
  module V1
    # ideas_class
    class IdeasController < ApplicationController
      def index
        @ideas = Category.fetch_ideas(params[:category_name])
        if @ideas.present?
          render json: @ideas, each_serializer: IdeaSerializer, root: 'data', adapter: :json
        else
          head :not_found
        end
      end

      def create
        Category.create_ideas!(idea_params[:category_name], idea_params[:body])
        head :created
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error e.message
        head :unprocessable_entity
      end

      private

      def idea_params
        params.permit(:category_name, :body)
      end
    end
  end
end
