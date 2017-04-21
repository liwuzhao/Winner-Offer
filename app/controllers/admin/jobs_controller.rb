class Admin::JobsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :update, :edit, :destroy]
  before_action :require_is_admin
  layout "admin"

  def index
    @jobs = case params[:order]
            when 'by resumes'
              Job.all.sort_by {|job| job.resumes.count }.reverse.paginate(:page => params[:page], :per_page => 4)
            when 'by_lower_bound'
              Job.order('wage_lower_bound DESC').paginate(:page => params[:page], :per_page => 4)
            when 'by_upper_bound'
              Job.order('wage_upper_bound DESC').paginate(:page => params[:page], :per_page => 4)
            else
              Job.recent.paginate(:page => params[:page], :per_page => 4)
            end
  end


  def new
    @job = Job.new
  end

  def create
   @job = Job.new(job_params)
   @job.user = current_user

     if @job.save
       redirect_to admin_jobs_path
     else
       render :new
     end
  end

  def show
    @job = Job.find(params[:id])


  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])

    if @job.update(job_params)
      redirect_to admin_jobs_path, notice:'Update Success'
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])

    @job.destroy
    redirect_to admin_jobs_path, alert:'Job deleted'
  end

  def hide
    @job = Job.find(params[:id])

    @job.hide!
    redirect_to :back
  end

  def publish
    @job = Job.find(params[:id])

    @job.publish!
    redirect_to :back
  end


  private

  def job_params
    params.require(:job).permit(:title, :description, :wage_upper_bound, :wage_lower_bound, :contact_email, :is_hidden, :company, :location, :number, :category)
  end

end
