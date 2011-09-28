# Import pre-existing viddler videos into the database
@viddler = Video::Viddler.authenticate!
Video::Viddler.videos.each do |element|
  v = Video.find_or_initialize_by_video_id(element['id'])
  v.title = element['title']
  v.description = element['description']
  v.url = element['url']
  v.thumbnail_url = element['thumbnail_url']
  puts "video #{v.video_id} #{v.new_record? ? 'created' : 'updated'}..."
  v.save!
end

# Re-slug
Video.all.each {|v| v.save!}

# Create a default admin user
admin = AdminUser.find_or_create_by_email 'manager@example.com'
admin.password = 'sanfran415:paragon'
admin.password_confirmation = 'sanfran415:paragon'
admin.save!
