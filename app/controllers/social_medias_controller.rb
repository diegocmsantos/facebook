class SocialMediasController < ApplicationController

	SERVER_REDIRECT_URI = "http%3A%2F%2Ffloating-meadow-2521.herokuapp.com%2Fsocial_medias%2Fgetaccesstoken"
	LOCALHOST_REDIRECT_URI = "http%3A%2F%2Flocalhost%3A3000%2Fsocial_medias%2Fgetaccesstoken"

	def face
		render "face_button"
	end

	def sendToFacebook
		redirect_to "https://www.facebook.com/dialog/oauth?client_id=221499501259361&redirect_uri=" + SERVER_REDIRECT_URI + "&scope=user_photos,user_relationships&state=teste"
	end

	def getAccessToken
		require 'net/http'
		require 'uri'

		@code = params[:code]
	    if @code

			url = URI.parse("https://graph.facebook.com/oauth/access_token?client_id=221499501259361&redirect_uri=" + SERVER_REDIRECT_URI + "&client_secret=81c8de19c6f7e93d771dcf1dfd0d0eae&code=" + @code)
			http = Net::HTTP.new(url.host, url.port)
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			http.use_ssl = true

			res = http.request_get(url.path + '?' + url.query)

			at = res.body.split "&"
			at2 = at.first.split "="
			@access_token = at2.second

			# url = URI.parse("https://graph.facebook.com/me/friends?access_token=" + @access_token)
			# http = Net::HTTP.new(url.host, url.port)
			# http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			# http.use_ssl = true
			# res = http.request_get(url.path + '?' + url.query)

			require 'open-uri'
			require 'json'
			result = JSON.parse(open("https://graph.facebook.com/me?access_token=" + @access_token).read)

			# @retorno = []
			# result["data"].each do |info|
			# 	if info != nil && info["name"] != nil
			# 		@retorno << info["name"]
			# 	end
			# end

			@full_name = result["first_name"] + " " + result["last_name"]
			@location = result["location"]["name"]
			@link = result["link"]
			@retorno = result["data"]

	    	respond_to do |format|
				format.html { render "face" }
				format.json { render :json => @retorno }
			end
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
