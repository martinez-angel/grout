module Api
  module V1
    class PageLevelMetricsController < ApplicationController
      respond_to :json
      before_filter :restrict_access, :only => [:show]

      def show
        respond_with Brand.find_by_brand_user_name!(params[:id]).page_level_metrics.all
      end

      private

      def restrict_access
        api_key = ApiKey.find_by_access_token(params[:access_token])
        head :unauthorized unless api_key
      end

    end
  end
end
