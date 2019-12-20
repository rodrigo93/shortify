module Api
  module V1
    class ShortenController < Api::V1::ApplicationController
      before_action :check_existence, only: %i[create]
      before_action :set_shorten, only: %i[show]

      # GET /api/v1/:shortcode
      def show
        render json: @shorten
      end

      # POST /api/v1/shorten
      def create
        @shorten = Shorten.new(shorten_params)

        if @shorten.save
          render json: @shorten, status: :created
        else
          render json: @shorten.errors, status: :bad_request
        end
      end

      private

      def check_existence
        return unless Shorten.find_by_shortcode(params.dig(:shorten, :shortcode))

        render json: { error: 'Shortcode has already been taken' }, status: :conflict, content_type: 'application/json'
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_shorten
        @shorten = Shorten.find(params[:shortcode])
      end

      # Only allow a trusted parameter "white list" through.
      def shorten_params
        params.require(:shorten).permit(:url, :shortcode)
      end
    end
  end
end
