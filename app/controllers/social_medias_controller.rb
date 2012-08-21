class SocialMediasController < ApplicationController

	def sendToFacebook
		redirect_to "https://www.facebook.com/dialog/oauth?client_id=221499501259361&redirect_uri=http%3A%2F%2Ffloating-meadow-2521.herokuapp.com%2Fsocial_medias%2Fgetaccesstoken&scope=user_photos,user_relationships&state=teste"
	end

	def getAccessToken
		require 'net/http'
		require 'uri'

		@code = params[:code]
		@access_token = params[:access_token]
	    if @code
			# Handle a successful save.
			flash[:success] = "ok!"
			@ret = @code
			#redirect_to "https://graph.facebook.com/oauth/access_token?client_id=221499501259361&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Ffacebook%2Fgetaccesstoken&client_secret=b978dc60ab73d27ec38ecc78931a6f72&code=" + @code

			url = URI.parse("https://graph.facebook.com/oauth/access_token?client_id=221499501259361&redirect_uri=http://localhost:3000/facebook/getaccesstoken&client_secret=81c8de19c6f7e93d771dcf1dfd0d0eae&code=" + @code)
			#url = URI.parse("http://google.com")
			http = Net::HTTP.new(url.host, url.port)
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			http.use_ssl = true

			req = Net::HTTP::Get.new(url.request_uri)
			res = http.request(req)
			puts res.body

			@access_token = @code
			#@ret = resp
			#puts @access_token
	    	#render "face"
		end
	    if @access_token
	    	flash[:success] = "error!"
	    	@ret = @access_token
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
