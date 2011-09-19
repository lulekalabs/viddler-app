module VideosHelper
  
  def video_embed_code(video_id, options = {})
    result = @viddler.get('viddler.videos.getEmbedCode', {:video_id => video_id}.merge(options))
    result['video']['embed_code']
  end
  
end
