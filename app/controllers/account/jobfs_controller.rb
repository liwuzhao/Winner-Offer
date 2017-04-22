#筛选出收藏的工作
class Account::JobfsController < ApplicationController

  def index
    @jobs = current_user.favorite_jobs.paginate(:page => params[:page], :per_page => 5)
  end

end
