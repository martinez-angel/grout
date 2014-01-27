module Api
  module V1
    class PostDataController < ApplicationController
      respond_to :json
      before_filter :restrict_access, :only => [:show]

      def show
        respond_with Post.find_by_post_id!(params[:id])
      end

      private

      def restrict_access
        api_key = ApiKey.find_by_access_token(params[:access_token])
        head :unauthorized unless api_key
      end

    end
  end
end
