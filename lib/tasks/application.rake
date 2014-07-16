namespace :videos do
  task :delete => :environment do
    @viddler = Video::Viddler.authenticate!

    # Remove through model instances
    Video.all.each do |video|
      video.destroy
      puts "* video #{video.video_id} model destroyed."
    end
    
    # Now remove the rest
    result = @viddler.get 'viddler.videos.getByUser', :per_page => 100
    result['list_result']['video_list'].each do |video|
      result = @viddler.post 'viddler.videos.delete', :sessionid => @viddler.sessionid, 
        :video_id => video['id']
      puts !!result['success'] ? "* video #{video['id']} manually destroyed." : "** video #{video['id']} destroy error."
    end
  end
end