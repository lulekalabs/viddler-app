module ViddlerApp
  extend self
  
  attr_reader :env
  @env = {}
  
  @env[:development] = {
    :viddler => {
      :api_key  => "17yncitdjk2bn1zfjiry",
      :user     => "bvision",
      :password => "sanfran415"
    }
  }

  @env[:production] = {
    :viddler => {
      :api_key  => "17yncitdjk2bn1zfjiry",
      :user     => "bvision",
      :password => "sanfran415"
    }
  }

  class Viddler
    class << self
      def api_key; ViddlerApp.env[Rails.env.to_sym][:viddler][:api_key]; end
      def user; ViddlerApp.env[Rails.env.to_sym][:viddler][:user]; end
      def password; ViddlerApp.env[Rails.env.to_sym][:viddler][:password]; end
    end
  end
end