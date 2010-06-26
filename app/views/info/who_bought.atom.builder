
atom_feed do |feed |
	feed.title "Who bought #{@product.title}"
	feed.updated @orders.first.created_at

    for order in @orders
    	feed.entry(order) do |entry|
    		entry.title "Order #{order.id}"
    		entry.summary :type=> 'xhtml' do | xhtml|
    			xhtml.p "Shipped to #{order.address}"

				xhtml.table do
					xhtml.tr do
						xhtml.th 'Product'
						xhtml.th 'Quantity'
						xhtml.th 'Total price'
					end

				    for item in order.line_items
				    	xhtml.tr do
				    		xhtml.tr do
				    			xhtml.td item.product.title
				    			xhtml.td item.quantity
				    			xhtml.td number_to_currency item.total_price
				    		end
				        end
					end # end of for item in order

					xhtml.tr do
						xhtml.th 'total', :colspan=>2
						xhtml.th number_to_currency order.line_items.map(&:total_price).sum
					end

					xhtml.p "Paid by #{order.pay_type}"

				end # end of xhtml.table

    		end # end of summary

    		entry.author do |author|
    			entry.name order.name
    			entry.email order.email
    		end

    	end # end of feed.entry(order)
    end
end