# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_admin               :boolean          default(FALSE)
#  username               :string
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :jobs
  has_many :resumes

  #投递历史
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


  #收藏
  has_many :job_favorites
  has_many :favorite_jobs, :through => :job_favorites, :source => :job

  #判断是否收藏
  def is_member_of?(job)
      favorite_jobs.include?(job)
  end

  #收藏
  def join!(job)
    favorite_jobs << job
  end

  def quit!(job)
    favorite_jobs.delete(job)
  end

  # 判断是否为admin
  def admin?
    is_admin
  end

  #显示用户名
  def display_name
    if self.username.present?
      self.username
    else
      self.email.split("@").first
    end
  end

end
