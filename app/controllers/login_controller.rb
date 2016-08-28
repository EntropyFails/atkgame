class LoginController < ApplicationController
    require "uri"
    require "net/http"
    require "net/https"
    skip_before_filter :setup_user, :only => :logout
    def login

        auth_params = { 
            'client_id' => Rails.application.config.twitch_api_key,
            'client_secret' => Rails.application.config.twitch_api_secret,
            'redirect_uri' => Rails.application.config.twitch_api_redirect_url,
            'grant_type' => 'authorization_code',
            'code' => params[:code]
        }
        uri = URI 'https://api.twitch.tv/kraken/oauth2/token'
        http = Net::HTTP.new(uri.host,uri.port)
        http.use_ssl = true if uri.scheme == 'https'
        auth_response = http.post(uri.path,URI.encode_www_form(auth_params))

        auth =  JSON.parse(auth_response.body)
        twitch_channel = kraken_channel(auth["access_token"])
        if twitch_channel["name"].blank?
            redirect_to root_url
            return
        end
        
        authed_twitch_user = User.where(:name => twitch_channel["name"]).first
        if authed_twitch_user.blank?
            authed_twitch_user = User.new
            authed_twitch_user.name = twitch_channel["name"]
        end
        authed_twitch_user.save

        #pair this down to the actual params you need
        session[:user] = authed_twitch_user.to_param
        redirect_to root_url
    end
    
    def logout
        reset_session
        redirect_to root_url
    end
    
    private 
    def kraken_channel(oauth)
        uri = URI 'https://api.twitch.tv/kraken/user'
        http = Net::HTTP.new(uri.host,uri.port)
        http.use_ssl = true if uri.scheme == 'https'
        initheader = {
            'Accept' => 'application/vnd.twitchtv.v2+json',
            'Authorization' => "OAuth #{oauth}",
            'Client-ID' => Rails.application.config.twitch_api_key
        }
        channel_response = http.get(uri.path,initheader)
        puts channel_response.body
        auth = JSON.parse(channel_response.body)
    end
    
end
