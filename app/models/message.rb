class Message < ActiveRecord::Base
  belongs_to :submitter

  validates :subject, :content, presence: true
end
