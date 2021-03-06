require "date"

class Post < ApplicationRecord
  has_one_attached :picture
  has_many :post_tags
  has_many :tags, through: :post_tags
  belongs_to :user

  validates :body, :post_date, :user_id, presence: true
  before_validation :set_post_date_today

  def self.search_post_by_user_id(id) #id can be array
    Post.where(user_id: id).order(post_date: :desc)
  end

  private
  def set_post_date_today
    if post_date.nil?
      self.post_date = DateTime.now()
    end
  end
end
