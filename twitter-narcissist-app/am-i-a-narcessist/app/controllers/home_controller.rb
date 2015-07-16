class HomeController < ApplicationController
  def index

  end

  def new
  
    @handle = User.new
    @handle.name = params[:handle]
    @handle.save
    
    redirect_to "/show/#{@handle.id}"
  end

  def show
  
    @handle = User.find(params[:id])

  end


end
