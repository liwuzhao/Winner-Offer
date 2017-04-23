class ResumesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_permission

  def new
    @job = Job.find(params[:job_id])
    @resume = Resume.new
    if current_user.has_applied?(@job)
      flash[:warning] = "你已经申请过该岗位了！"
      redirect_to job_path(@job)
    end
  end

  def create
    @job = Job.find(params[:job_id])
    @resume = Resume.new(resume_params)
    @resume.job = @job
    @resume.user = current_user

    if @resume.save
      redirect_to job_path(@job)
      current_user.apply!(@job)
      flash[:notice] = "成功提交简历"
    else
      render :new
    end
  end

  private

  def check_permission
    @job = Job.find(params[:job_id])
    if current_user.admin?
      flash[:warning] = "只有普通用户才能投递简历"
      redirect_to job_path(@job)
    end
  end

  def resume_params
    params.require(:resume).permit(:content, :attachment)
  end
end
