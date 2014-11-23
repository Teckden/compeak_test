class Submitter < ActiveRecord::Base

  has_many :messages, dependent: :destroy

  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
end
