module Api
  module V1
    class ShortenController < ApplicationController
      before_action :check_existence, only: %i[create]
      before_action :validate_params, only: %i[create]

      before_action :set_shorten, only: %i[show]

      rescue_from ActiveRecord::RecordNotFound do
        render json: {error: 'The shortcode cannot be found in the system'}, status: :not_found
      end

      # GET /api/v1/:shortcode
      def show
        @shorten.register_redirect!

        render json: {Location: @shorten.url}
      end

      # POST /api/v1/shorten
      def create
        @shorten = Shorten.new(shorten_params)

        if @shorten.save
          render json: {shortcode: @shorten.shortcode}, status: :created
        else
          render json: @shorten.errors, status: :unprocessable_entity
        end
      end

      private

      def check_existence
        return unless Shorten.find_by_shortcode(params[:shortcode])

        render json: {error: 'Shortcode has already been taken'}, status: :conflict, content_type: 'application/json'
      end

      def validate_params
        return if shorten_params.has_key?(:url)

        render json: {url: "can't be blank"}, status: :bad_request
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_shorten
        @shorten = Shorten.find_by!(shortcode: params[:shortcode])
      end

      # Only allow a trusted parameter "white list" through.
      def shorten_params
        params.permit(:url, :shortcode)
      end
    end
  end
end
