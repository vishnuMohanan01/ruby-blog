require "digest"

class User < ApplicationRecord
  attr_accessor :password

  validates :email, {uniqueness: true}
  validates :email, {length: {in: 5..50}}
  validates :email, format: { with: /\A[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}\z/i }
  validates :password, {confirmation: true} # adds password_confirmation attribute in the model

  has_one :profile
  has_many :articles, -> {order "published_at DESC, title ASC"}, dependent: :nullify
  has_many :replies, :through => :articles, :source => :comments

  def authenticate(email_string, password_string)
    user = find_by email:  email_string
    user if user && self.authenticated?(password_string)
  end

  def authenticated?(password_string)
    hashed_password == encrypt(password_string)
  end

  protected

  def encrypt_new_password
    nil if password.blank?
    hashed_password = encrypt(password)
  end

  def encrypt(string)
    Digest::SHA1.hexdigest(string)
  end
end
