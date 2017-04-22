class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :jobs
  has_many :resumes

  has_many :job_relationships
  has_many :participated_jobs, :through => :job_relationships, :source => :job
  has_many :applied_jobs, :through => :job_relationships, :source => :job


  # 判断user是否申请工作
  def has_applied?(job)
    applied_jobs.include?(job)
  end

  #申请工作
  def apply!(job)
    applied_jobs << job
  end


  # 判断是否收藏
  def is_member_of(job)
    participated_jobs.include?(job)
  end

  # 实际收藏和取消收藏

  def join!(job)
    participated_jobs << job
  end


  def quit!(job)
    participated_jobs.delete(job)
  end

  # 判断是否为admin
  def admin?
    is_admin
  end

  def display_name
    if self.username.present?
      self.username
    else
      self.email.split("@").first
    end
  end

end
