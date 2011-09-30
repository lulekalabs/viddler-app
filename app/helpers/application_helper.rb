require 'digest/md5'
module ApplicationHelper
  
  def error_messages(target, wrap = false)
    html = ""
    html += %(<div id="errorExplanation">) if wrap
    html += %(<p><b>Oh snap! You got an error!</b> Change the following <i>#{pluralize(target.errors.count, "error")}</i> and try again.</p>)
    html += %(<ul>)
    target.errors.full_messages.each do |msg|
      html += %(<li>#{msg}</li>)
    end
    html += %(</ul>)
    html += %(</div>) if wrap
    html.html_safe
  end
  alias_method :error_messages_for, :error_messages

  def page_title
    @video && !@video.new_record? ? "#{@video.title} - #{t("site.name")}" : "#{t("site.name")}"
  end

  def fb_title
    @video && !@video.new_record? ? "#{t("facebook", :title => @video.title)} - #{t("site.name")}" : "#{t("site.name")}"
  end

  def fb_thumbnail_url
    @video ? @video.thumbnail_url : ""
  end

  def video_embed_code(video_id, options = {})
    result = Video::Viddler.session.get('viddler.videos.getEmbedCode', {:video_id => video_id}.merge(options))
    result['video']['embed_code'].html_safe
  end

  def gravatar_url_for(email, options = {})
    "#{request.protocol}www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.strip.downcase)}"
  end

end
