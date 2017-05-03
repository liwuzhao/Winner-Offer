#筛选出已投递的工作
class Account::JobsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_permission

  def index
    @jobs = current_user.applied_jobs.paginate(:page => params[:page], :per_page => 5)
  end

  def check_permission
    if current_user && current_user.admin?
      flash[:warning] = "只有普通用户才能投递简历"
      redirect_to root_path
    end
  end
end
