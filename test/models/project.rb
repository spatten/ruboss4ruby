class Project < ActiveRecord::Base
  belongs_to :user
  has_many :tasks
  
  default_xml_includes :tasks
end
