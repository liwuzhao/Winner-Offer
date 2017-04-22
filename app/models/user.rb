class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :jobs
  has_many :resumes


  has_many :job_relationships
  has_many :applied_jobs, :through => :job_relationships, :source => :job

  #判断是否投递
  def has_applied?(job)
    applied_jobs.include?(job)
  end
  #投递
  def apply!(job)
    applied_jobs << job
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
