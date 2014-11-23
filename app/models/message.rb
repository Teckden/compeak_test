class Message < ActiveRecord::Base
  validates :subject, :content, presence: true
end
