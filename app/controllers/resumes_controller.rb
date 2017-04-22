class ResumesController < ApplicationController
  before_action :authenticate_user!

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

  def resume_params
    params.require(:resume).permit(:content, :attachment)
  end
end
