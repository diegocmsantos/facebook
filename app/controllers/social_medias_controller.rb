class SocialMediasController < ApplicationController

	def sendToFacebook
		redirect_to "https://www.facebook.com/dialog/oauth?client_id=221499501259361&redirect_uri=http%3A%2F%2Ffloating-meadow-2521.herokuapp.com%2Fsocial_medias%2Fgetaccesstoken&scope=user_photos,user_relationships&state=teste"
	end

	def getAccessToken
		require 'net/http'
		require 'uri'

		@code = params[:code]
		@access_token = params[:access_token]
	    if @code && !@access_token

			url = URI.parse("https://graph.facebook.com/oauth/access_token?client_id=221499501259361&redirect_uri=http%3A%2F%2Ffloating-meadow-2521.herokuapp.com%2Fsocial_medias%2Fgetaccesstoken&client_secret=81c8de19c6f7e93d771dcf1dfd0d0eae&code=" + @code)
			http = Net::HTTP.new(url.host, url.port)
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			http.use_ssl = true

			res = http.request_get(url.path + '?' + url.query)
			@retorno = res.body

			#at = res.body.split "&"
			#@access_token = at.first.delete "access_token="
			@access_token = res.body
			
	    	render "face"
	    end

	end

	def listFriends
		@access_token = params[:access_token]
		if @access_token
			@ret = @access_token
		else
			@ret = "error"
		end
	end

end
