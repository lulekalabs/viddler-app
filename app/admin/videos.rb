ActiveAdmin.register Video do

  scope :all
  scope :registered
  scope :published
  scope :unpublished

  index do
    column(:thumbnail) do |video|
      link_to(image_tag(video.thumbnail_url, :size => "57x43"), [:admin, video])
    end
    column(:title) do |video|
      link_to(video.title, [:admin, video])
    end
    column(:status) do |video|
      video_status_tag(video)
    end
    default_actions
  end
  
  form do |f|
    f.inputs do
      f.input :user
      f.input :title
      f.input :description
      f.input :tags
      f.input :created_at
      f.input :published_at
    end
    f.buttons
  end

  show do
    panel "Details" do
      attributes_table_for resource do
        row :status do
          video_status_tag(resource)
        end
        row :title
        row :description
        row :tags
        row :source do
          resource.human_source_name
        end
      end
    end
    
    if resource.registered?
      panel "User" do
        attributes_table_for resource.user do
          row :name
          row :email
        end
      end
    end
  end

  sidebar "Video Player", :only => [:edit, :show] do
    render "player"
  end
  
  member_action :toggle do
    if resource.published_at
      resource.update_attribute(:published_at, nil)
    else
      resource.update_attribute(:published_at, Time.now)
    end
    redirect_to admin_video_path(resource)
  end

  action_item :only => [:edit, :show] do
    if resource.registered? && !resource.published?
      link_to "Activate Video", toggle_admin_video_path(resource), :class => "member_link view_link"
    elsif resource.registered? && resource.published?
      link_to "Deactivate Video", toggle_admin_video_path(resource), :class => "member_link view_link"
    end
  end

  action_item :only => :edit do
    link_to "Show Video", resource_path(resource), :class => "member_link view_link"
  end

  controller do
    before_filter :viddler_authenticate
    
    protected
    
    def viddler_authenticate
      Video::Viddler.authenticate!
    end
    
  end
  
end
