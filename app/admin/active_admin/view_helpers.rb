def video_status_tag(video)
  if video.published?
    status_tag("published", :ok)
  elsif video.authenticated?
    status_tag("ready", :warning)
  else
    status_tag("new", :cancel)
  end
end
