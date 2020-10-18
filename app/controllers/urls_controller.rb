require 'addressable/uri'
require 'securerandom'

class UrlsController < ApplicationController

    SCHEMES = %w(http https)

    def valid_url?(url)
        parsed = Addressable::URI.parse(url) or return false
        SCHEMES.include?(parsed.scheme)
    rescue Addressable::URI::InvalidURIError
        false
    end

    def create
        # Check that URL was provided
        if params[:url].blank?
            response = { "error" => "no url provided" }
            render json: response, status: :bad_request
            return
        end

        # Check that URL is valid
        if !valid_url?(params[:url])
            response = { "error" => "invalid url provided" }
            render json: response, status: :bad_request
            return
        end

        # Check if URL exists in database already
        existing_url = Url.find_by url: params[:url]
        unless existing_url.nil?
            response = { url: existing_url.url, slug: existing_url.slug }
            render json: response, status: :ok
            return
        end

        # Generate unique slug
        loop do
            @generated_slug = SecureRandom.hex(3)
            break if !Url.exists?(slug: @generated_slug)
        end

        # Create database record for url and slug
        url = Url.create(url: params[:url], slug: @generated_slug)

        # Return the url and slug in json
        response = { "url": url.url, "slug": url.slug }
        render json: response, status: :created
    end


    def show
        begin
            url = Url.find_by! slug: params[:slug]
        rescue ActiveRecord::RecordNotFound => e
            render json: { url: nil }, status: :not_found
            return
        end
        render json: { url: url.url }, status: :ok
    end
end