class Video < ActiveRecord::Base
  attr_accessor :viddler, :source
  belongs_to :user
  belongs_to :session

  validate :video_id, :uniqueness => {:case_sensitive => false}
  validate :title, :uniqueness => {:case_sensitive => false}

  accepts_nested_attributes_for :user

  class << self

    def instance_for(attributes = {})
      record = new attributes
      record.user = nil if record.webcam?
      record
    end
  
    def new_with_cast(*a, &b)  
      if (h = a.first).is_a? Hash and (source = h.delete(:source) || h.delete('source')) and 
        (k = source.class == Class ? source : klass(source)) != self
        raise "type not descendent of Video" unless k < self  # klass should be a descendant of us  
        return k.new(*a, &b)  
      end  
      new_without_cast(*a, &b)  
    end  
    alias_method_chain :new, :cast
    
    def klass(source = nil)
      [RecordedVideo, UploadedVideo].each do |sc|
        return sc if !source.blank? && (sc.source.to_s == source.to_s || sc.name.underscore == source.to_s)
      end
      Video
    end

    def source; nil; end
  end

  def webcam?
    self.class.source == :webcam
  end

  def upload?
    self.class.source == :upload
  end
  
  def to_param
    self.video_id
  end
  
end
