# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
@viddler = Viddler::Client.new(ViddlerApp::Viddler.api_key)
@viddler.xauthenticate! ViddlerApp::Viddler.user, ViddlerApp::Viddler.password, :get_record_token => "1"
result = @viddler.get 'viddler.videos.getByUser', :per_page => 100
result['list_result']['video_list'].each do |element|
  v = Video.find_or_initialize_by_video_id(element['id'])
  v.title = element['title']
  v.description = element['description']
  v.url = element['url']
  v.thumbnail_url = element['thumbnail_url']
  puts "video #{v.video_id} #{v.new_record? ? 'created' : 'updated'}..."
  v.save!
end
