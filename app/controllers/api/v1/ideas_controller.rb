# frozen_string_literal: true

module Api
  module V1
    # ideas_class
    class IdeasController < ApplicationController
      def index
        if params[:category_name].present?
          category = Category.find_by(name: params[:category_name])
          if category.present?
            @ideas = category.ideas
            render json: @ideas, each_serializer: IdeaSerializer
          else
            head :not_found
          end
        else
          @ideas = Idea.eager_load(:category)
          render json: @ideas, each_serializer: IdeaSerializer
        end
      end

      def create
      end
    end
  end
end
