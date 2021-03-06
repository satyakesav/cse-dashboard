class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      if (@micropost.anony && current_user.id != 1)
          flash[:success] = "Post created anonymously. However, you are being watched!"
      else
        flash[:success] = "Post created!"
      end
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end
  
  def update
    @micropost = Micropost.find(params[:id])
    if @micropost.update_attributes(micropost_params)
      # Handle a successful update.
      flash[:success] = "Post successfully updated!"
      redirect_back fallback_location: root_path
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Post deleted"
    redirect_to request.referrer || root_url
  end
  
  def show
    @micropost = Micropost.find(params[:id])
  end
  
  def index
    str = params["search"].to_str
    @microposts = Micropost.search(str)
  end

  
  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture, :tag, :anony, :resolved)
  end
  
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
  
end