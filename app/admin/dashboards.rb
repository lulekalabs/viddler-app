ActiveAdmin::Dashboards.build do

  section "Recent Submissions" do
    table_for Video.where(:published_at => nil).recent(10) do |t|
      column(:thumbnail) do |video|
        link_to(image_tag(video.thumbnail_url, :size => "57x43", :alt => video.title, :title => video.title), [:admin, video])
      end
      t.column("Status") {|video| video_status_tag(video)}
    end
  end

  section "Recently Published" do
    table_for Video.published.recent(10) do |t|
      column(:thumbnail) do |video|
        link_to(image_tag(video.thumbnail_url, :size => "57x43", :alt => video.title, :title => video.title), [:admin, video])
      end
      t.column("Status") {|video| video_status_tag(video)}
    end
  end

  section "Recent Users" do
    table_for User.recent(10) do |t|
      column(:name) do |user|
        link_to(user.name, [:admin, user])
      end
      t.column :email
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
