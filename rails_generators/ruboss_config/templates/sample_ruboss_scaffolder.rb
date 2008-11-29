require 'rubygems'
require 'ruboss4ruby/ruboss_scaffolder'

ruboss_scaffold('user') do |s|
  s.string :first_name
  s.string :last_name
  s.has_many :projects
end

ruboss_scaffold('project') do |s|
  s.string :name
  s.date :start_date, :completion_date
  s.has_many :tasks
  s.belongs_to :user
end

ruboss_scaffold('task') do |s|
  s.string :name
  s.boolean :completed
  s.belongs_to :project
end