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
      end
    end
  end
end
