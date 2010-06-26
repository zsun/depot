class InfoController < ApplicationController
  # to retrieve the info:
   # http://localhost:3000/info/who_bought/5     <-- this is  the default format
   # http://localhost:3000/info/who_bought/5.html
   # http://localhost:3000/info/who_bought/5.xml
   # http://localhost:3000/info/who_bought/5.json
   # http://localhost:3000/info/who_bought/5.atom

   def who_bought # json format
    @product = Product.find(params[:id])
    @orders = @product.orders
    respond_to do | format |

      # note: here we define all the request hander, depending on the request extensiion
      #       e.g. .../5.json or .../8.atom, the corresponding hander will be picked at runtime
      format.html
      format.json { render :layout => false,
        :json=>@product.to_json(:include=> :orders)
      }
      # xml fomat
      # format.xml { render :layout => false }

      #autogenerating xml
      format.xml { render :layout => false,
          :xml => @product.to_xml(:include => :orders )
        }
      format.atom { render :layout => false }
    end
  end



 protected
 def authorize

 end

end
