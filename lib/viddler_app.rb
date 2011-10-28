module ViddlerApp
  extend self
  
  attr_reader :env
  @env = {}
  
  @env[:development] = {
    :viddler => {
      # :api_key  => "7adz8onik15d1sfqcm0l",
      # :user     => "Extole",
      # :password => "G3Xnzgy1zGrcLc"
      :api_key  => "19naunv1iq7cz1q7xw4l",
      :user     => "bvision_dev",
      :password => "sanfran415"
    }
  }

  @env[:production] = {
    :viddler => {
      # :api_key  => "7adz8onik15d1sfqcm0l",
      # :user     => "Extole",
      # :password => "G3Xnzgy1zGrcLc"
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