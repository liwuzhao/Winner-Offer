class Account::JobsController < ApplicationController
  before_action :authenticate_user!

  def index
    @jobs = current_user.participated_jobs.paginate(:page => params[:page], :per_page => 4)
  end
end
