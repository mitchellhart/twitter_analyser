class HomeController < ApplicationController

  def new
    @handle = User.new
    @handle.name = params[:handle]
    handle_valid?
  end

  def handle_valid?
    handle = @handle.name.strip
    if /^[A-Za-z0-9_]{1,15}|^@[A-Za-z0-9_]{1,15}/.match(handle).to_s == handle# returns nil or a match
      
      if @handle.score_f == nil
        redirect_to "/error"
      else
        @handle.save
        @handle.run
        redirect_to "/show/#{@handle.id}"
      end
    else 
      render :index
    end
  end

  def show
    @handle = User.find(params[:id])
    @celeb = @handle.find_closest_celeb
  
  end

  def topten   
    @topten = User.select(:name, :score_f).order(score_f: :desc).limit(10).uniq(:name)
  end

end
