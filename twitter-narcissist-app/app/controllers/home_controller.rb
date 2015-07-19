class HomeController < ApplicationController

  class HandleError < StandardError
  end

  def index

  end

  def new
    @handle = User.new
    @handle.name = params[:handle]
    if @handle.name = ""
      flash[:notice] = "This user is not activated."
      redirect_to "/"
    else 
      @handle.save
      @handle.run
      redirect_to "/show/#{@handle.id}"
    end
  end

  def show
  
    @handle = User.find(params[:id])
    @celeb = @handle.find_closest_celeb
  end

  def topten
    
    @topten = User.select(:name, :score_f).order(score_f: :desc).limit(10)
     

  end


end
