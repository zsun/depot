class Product < ActiveRecord::Base
  validates_presence_of :title, :description, :image_url
  validates_numericality_of(:price, :message => "price needs to be numerical")
  validate :price_must_be_at_least_a_cent
  validates_uniqueness_of(:title, :message => "title #{:title} already exists")

  validates_format_of(:image_url, :with => %r{\.(gif|jpg|png)$}i, :message => "image url needs to end with .gif, .jpg or .png")
  protected
  def price_must_be_at_least_a_cent
    errors.add(:price, "should be at lease a cent") if price.nil? || price < 0.01
  end
  def self.find_product_for_sale
    find(:all, :order=>"title")
  end
end
