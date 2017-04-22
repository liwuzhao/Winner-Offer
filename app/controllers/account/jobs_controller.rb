#筛选出已投递的工作
class Account::JobsController < ApplicationController
  before_action :authenticate_user!

  def index
    @jobs = current_user.applied_jobs.paginate(:page => params[:page], :per_page => 5)
  end
end
