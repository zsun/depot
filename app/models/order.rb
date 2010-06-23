class Order < ActiveRecord::Base
  has_many :line_items

  PAYMENT_TYPES = [
    #displayed   stored in DB
    ["Check",    "check"],
    ["Credit card", "cc"],
    ["Purchase order", "po"]
  ]
    validates_presence_of :name, :address, :email, :pay_type
   validates_inclusion_of :pay_type, :in =>
    PAYMENT_TYPES.map {|disp, value| value }

  def add_line_items_from_cart(cart)
    cart.items.each do |item|
      li = LineItem.from_cart_item(item) #note, we are calling a static method on class of LineItem
      # Q: how come the following does not work?
      # got error - undefined local variable or method `line_items' for #<Order:0x5afdc74>
      # A: this is because the misspell of has_many :line_items, I was using has_many :line_item (without s)
      line_items << li
    end
  end
end
