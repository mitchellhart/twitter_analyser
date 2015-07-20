class HomeController < ApplicationController

  def index
  end

  def new
    @handle = User.new
    @handle.name = params[:handle]
    handle_valid?
  end

  def handle_valid?
    handle = @handle.name.strip
    if /^[A-Za-z0-9_]{1,15}|^@[A-Za-z0-9_]{1,15}/.match(handle) # returns nil or a match
      @handle.save
      @handle.run
      redirect_to "/show/#{@handle.id}"
    else 
      redirect_to root_path
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
