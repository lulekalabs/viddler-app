module VideosHelper
  
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
  
  def delete_video_link(video = @video)
    %(<a href="#{delete_video_path(video.video_id)}" class="btn secondary delete-video" rel="nofollow" data-content="#{video.video_id}">#{t ".delete"}</a>).html_safe
  end

  def vote_video_link(video = @video)
    if video.published?
      text, state = video.voted?(current_session) ? [t(".voted"), "voted"] : [t(".vote"), "active"]
      %(<a href="#" class="btn primary vote-video #{state}" rel="nofollow" data-vote-video-url="#{video_vote_path(video)}" data-video-id="#{video.video_id}">#{text}</a>).html_safe
    end
  end

  def video_status_label(video)
    if video.published?
      "success"
    elsif video.registered?
      "notice"
    else
      "default"
    end
  end
  
end
