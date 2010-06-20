class AddTestData < ActiveRecord::Migration
  def self.up
    Product.delete_all
    Product.create(:title=> 'Progmatic Version Control',
        :description=>%{<p> this book is for this testing purpose</p>},
        :image_url=>'/images/rails.jpg',
        :price=>28.50
    )
    # ...
  end

  def self.down
    Product.delete_all
  end
end
