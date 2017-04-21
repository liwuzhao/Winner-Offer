class Account::JobsController < ApplicationController
  before_action :authenticate_user!

  def index
  @jobs = case params[:order]
          when 'by_lower_bound'
            current_user.participated_jobs.published.order('wage_lower_bound DESC').paginate(:page => params[:page], :per_page => 4)
          when 'by_upper_bound'
            current_user.participated_jobs.published.order('wage_upper_bound DESC').paginate(:page => params[:page], :per_page => 4)
          else
            current_user.participated_jobs.published.recent.paginate(:page => params[:page], :per_page => 4)
          end

  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :wage_lower_bound, :wage_upper_bound, :contact_email, :is_hidden, :location, :company, :number, :category)
  end

end
