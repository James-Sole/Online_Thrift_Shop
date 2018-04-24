class User < ActiveRecord::Base
  has_secure_password

  before_save :downcase
  has_many :sellers, foreign_key: :seller_id, class_name: 'Product'
  has_many :sellinging, through: :sellers, source: :seller

  has_many :buyers, foreign_key: :buyer_id, class_name: 'Product'
  has_many :buying, through: :buyers, source: :buyer

  validates :name, :alias, :email, presence: true

  private
    def downcase
      self.name.downcase!
      self.alias.downcase!
      self.email.downcase!
    end
end
