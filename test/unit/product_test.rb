require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :products
  test "unique title" do
      product=Product.new(:title=>products(:ruby_book).title,
                :price=>1,
                :description=>"a book description",
                :image_url=>name
              )
     assert !product.save
     assert_equal "title title already exists", product.errors.on("title")
  end

  test "invalid with empty attributes" do
    product = Product.new
    assert !product.valid?
    assert product.errors.invalid?(:title)
  end

  test "positive price" do
    product = Product.new(:title=>"My Book title",
              :description=>"yy",
              :image_url=>"zzz.jpg"
      )

    product.price=1
    assert product.valid?

    product.price=-1
    assert !product.valid?
#     assert_equal "should be at lease 0.01", product.errors.on("price")
    assert_equal "should be at lease a cent", product.errors.on("price")

    product.price= 0
    assert !product.valid?
    assert_equal "should be at lease a cent", product.errors.on("price")
  end

  test "image url" do
    ok = %w{fred.gif fred.jpg fred.png fred.Jpg http://a.b.com/fred.jpg}
    bad = %w{fred.doc fred.gif/more fred.gif.more}

    ok.each do |name|
      product=Product.new(:title=>"a book",
                :price=>1,
                :description=>"a book description",
                :image_url=>name
              )
      puts "asserting #{product}..."
      assert product.valid?, product.errors.full_messages
    end

    bad.each do |name|
      product=Product.new(:title=>"a book",
                :price=>1,
                :description=>"a book description",
                :image_url=>name
              )
      puts "asserting #{product}..."
      assert !product.valid?, product.errors.full_messages
    end
  end

end
