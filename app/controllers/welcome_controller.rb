class WelcomeController < ApplicationController
    
  def index
    redirect_to barcode_index_path
  end
end
