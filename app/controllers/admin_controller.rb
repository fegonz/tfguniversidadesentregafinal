class AdminController < ApplicationController
  before_action :authenticate_user!
  def index
    @universidads = Universidad.all
  
  end

  def devuelveGrados(uni)
    
     grados =  Grado.where("universidad = ?", uni)
    
    return grados.count
  end

  helper_method :devuelveGrados

    
end
