class Comment < ApplicationRecord
  validates :article_id, :email, :name, :body, {presence: true}
  validates :article_should_be_published

  belongs_to :article

  after_create :email_article_author

  def article_should_be_published
    errors.add(:article_id, "Article [#{article_id}] not published") if article && !article.published?
  end

  def email_article_author
    puts "We will notify the author in chapter 12" if article.user
  end
end
