class Admin::JobsController < Admin::BaseController
  before_action :authenticate_user! , only: [:new, :create, :update, :edit, :destroy]
  before_action :find_job_and_check_permission , only: [:edit, :update, :destroy]

  def index
    @jobs = current_user.jobs.paginate(:page => params[:page], :per_page => 15)
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
      redirect_to admin_jobs_path, notice:'更新成功'
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])

    @job.destroy
    redirect_to admin_jobs_path, alert:'已删除该招聘信息'
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

  def find_job_and_check_permission
    @job = Job.find(params[:id])

    if @job.user != current_user
      redirect_to admin_jobs_path, alert: "你没有权限进行此操作。"
    end
  end

  def job_params
    params.require(:job).permit(:title, :description, :wage_upper_bound, :wage_lower_bound, :contact_email, :is_hidden, :company, :location, :number, :category)
  end

end
