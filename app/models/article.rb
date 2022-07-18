class Article < ApplicationRecord
  validates :title, :body, presence: true

  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :comments

  scope :published, -> {where.not(published_at: nil)}
  scope :draft, -> {where(published_at: nil)}
  scope :recent, -> {where("published_at > :recent_datetime_threshold", { :recent_datetime_threshold => 1.week.ago.to_date })}
  scope :search_title, -> (term) {where("title LIKE ?", "%#{term}%")}

  def long_title
    "#{title} - #{published_at}"
  end

  def published?
    published_at.present?
  end
end
