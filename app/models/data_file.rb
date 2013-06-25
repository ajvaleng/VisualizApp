class DataFile
  include Mongoid::Document

  field :file, :type => String  
  mount_uploader :file, FileUploader
  has_and_belongs_to_many :users
  attr_accessible :file, :user_ids, :file_cache, :file_asset

  rails_admin do
    list do
      field :file do
        # pretty_value do # used in list view columns and show views, defaults to formatted_value for non-association fields
        #   value.file_url
        # end
      end
    end
  end
  
end
