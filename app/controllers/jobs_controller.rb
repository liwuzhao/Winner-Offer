class JobsController < ApplicationController
  def index
    @jobs = case params[:order]
            when 'by resumes'
              Job.all.sort_by {|job| job.resumes.count }.reverse
            when 'by_lower_bound'
              Job.published.order('wage_lower_bound DESC').paginate(:page => params[:page], :per_page => 4)
            when 'by_upper_bound'
              Job.published.order('wage_upper_bound DESC').paginate(:page => params[:page], :per_page => 4)
            else
              Job.published.recent.paginate(:page => params[:page], :per_page => 4)
            end
  end

  def show
    @job = Job.find(params[:id])

    if @job.is_hidden
      flash[:warning] = "This Job already archieved"
      redirect_to root_path
    end
  end



  private

  def job_params
    params.require(:job).permit(:title, :description, :wage_lower_bound, :wage_upper_bound, :contact_email, :is_hidden, :location, :company, :number, :category)
  end
end
