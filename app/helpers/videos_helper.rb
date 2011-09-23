module VideosHelper
  
  def video_embed_code(video_id, options = {})
    result = @viddler.get('viddler.videos.getEmbedCode', {:video_id => video_id}.merge(options))
    result['video']['embed_code']
  end
  
  def video_upload_url
    @video_upload_url or raise "viddler upload url not available, call prepare_upload."
  end

  def video_upload_token
    @video_upload_token or raise "viddler upload token not available, call prepare_upload."
  end
  
end
