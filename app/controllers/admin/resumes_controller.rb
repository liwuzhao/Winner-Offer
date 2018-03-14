class Admin::ResumesController < Admin::BaseController
  before_action :authenticate_user!

  def index
    @job = Job.find(params[:job_id])
    @resumes = @job.resumes.recent.paginate(:page => params[:page], :per_page => 5)
  end
end
