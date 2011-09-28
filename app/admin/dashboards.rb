ActiveAdmin::Dashboards.build do

  section "Recent Videos" do
    ul do
      Video.recent(5).collect do |video|
        li link_to(video.title, admin_video_path(video))
      end
    end
  end

  section "Recent Users" do
    ul do
      User.recent(5).collect do |user|
        li link_to(user.name, admin_user_path(user))
      end
    end
  end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

end
