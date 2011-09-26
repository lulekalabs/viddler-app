module VideosHelper
  
  def video_embed_code(video_id, options = {})
    result = @viddler.get('viddler.videos.getEmbedCode', {:video_id => video_id}.merge(options))
    result['video']['embed_code'].html_safe
  end
  
  def video_upload_url
    @video_upload_url or raise "viddler upload url not available, call prepare_upload."
  end

  def video_upload_token
    @video_upload_token or raise "viddler upload token not available, call prepare_upload."
  end

  def edit_video_link(video = @video)
    %(<a id="#{edit_video_link_dom_id(video)}" data-controls-modal="#{edit_video_dom_id(video)}" data-backdrop="static"></a>).html_safe
  end
  
  def video_dom_id(video = @video)
    "modal-video-#{video.video_id}"
  end
  
  def edit_video_dom_id(video = @video)
    "edit-modal-video-#{video.video_id}"
  end

  def edit_video_link_dom_id(video = @video)
    "edit-modal-video-#{video.video_id}-link"
  end
  
end
