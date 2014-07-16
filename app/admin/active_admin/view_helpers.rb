def video_status_tag(video)
  if video.published?
    status_tag(video.human_status_name, :ok)
  elsif video.registered?
    status_tag(video.human_status_name, :warning)
  else
    status_tag(video.human_status_name, :cancel)
  end
end
