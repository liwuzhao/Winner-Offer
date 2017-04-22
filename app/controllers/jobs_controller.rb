class JobsController < ApplicationController
  before_action :validate_search_key, only: [:search]
  before_action :authenticate_user!, only: [:quit]


  # def index
  #   if params[:category].present?
  #     @category = params[:category]
  #     if @category == 'all'
  #       @jobs = Job.published.recent.paginate(:page => params[:page], :per_page => 10)
  #     else
  #       @jobs = Job.where(:is_hidden => false, :category => @category).recent.paginate(:page => params[:page], :per_page => 10)
  #     end
  #
  #   else
  #     @jobs = Job.published.recent.paginate(:page => params[:page], :per_page => 10)
  #   end
  # end


  def index
    # 按职位分类
    if params[:category].present?
      @category = params[:category]
      if @category == '所有职位'
        @jobs = Job.published.recent.paginate(:page => params[:page], :per_page => 5)
      else
        @jobs = Job.published.where(:category => @category).recent.paginate(:page => params[:page], :per_page => 5)
      end

    # 不分类
    else
      @jobs = case params[:order]
              when 'by_lower_bound'
                Job.published.order('wage_lower_bound DESC').paginate(:page => params[:page], :per_page => 5)
              when 'by_upper_bound'
                Job.published.order('wage_upper_bound DESC').paginate(:page => params[:page], :per_page => 5)
              else
                Job.published.recent.paginate(:page => params[:page], :per_page => 5)
              end
    end

  end


  def show
    @job = Job.find(params[:id])

    if @job.is_hidden
      flash[:warning] = "This Job already archieved"
      redirect_to root_path
    end
  end

  def join
    @job = Job.find(params[:id])

    if !current_user
      redirect_to job_path(@job)
      flash[:warning] = "你需要先登录账号"
    elsif !current_user.is_member_of(@job)
      current_user.join!(@job)
      flash[:notice] = "收藏成功"
    else
      flash[:warning] = "你已经收藏这个岗位了！"
    end
      redirect_to job_path(@job)
    end



  def quit
    @job = Job.find(params[:id])
    if current_user.is_member_of(@job)
      current_user.quit!(@job)
      flash[:alert] = "已移出收藏"
    else
      flash[:warning] = "你还没有收藏"
    end
    redirect_to job_path(@job)
  end



  def search
      if @query_string.present?
        search_result = Job.published.ransack(@search_criteria).result(:distinct => true)
        @jobs = search_result.paginate(:page => params[:page], :per_page => 5 )
      end
  end

  protected
  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "") if params[:q].present?
    @search_criteria = search_criteria(@query_string)
  end


  def search_criteria(query_string)
    { :title_or_location_or_category_or_company_cont => query_string }
  end


  private

  def job_params
    params.require(:job).permit(:title, :description, :wage_lower_bound, :wage_upper_bound, :contact_email, :is_hidden, :location, :company, :number, :category)
  end
end
