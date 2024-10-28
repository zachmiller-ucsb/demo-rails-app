class Post < ApplicationRecord
  include Visible

  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  scope :by_author_name, ->(name) {
    joins(:user).where(users: { name: name })
  }
end
