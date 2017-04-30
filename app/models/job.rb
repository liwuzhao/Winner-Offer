# == Schema Information
#
# Table name: jobs
#
#  id               :integer          not null, primary key
#  title            :string
#  description      :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  wage_upper_bound :integer
#  wage_lower_bound :integer
#  contact_email    :string
#  is_hidden        :boolean          default(TRUE)
#  location         :string
#  company          :string
#  number           :integer
#  category         :string
#

class Job < ApplicationRecord
  validates :title , presence:true
  validates :contact_email, presence:true
  validates :wage_upper_bound, presence:true
  validates :wage_lower_bound, presence:true
  validates :location, presence:true
  validates :company, presence:true
  validates :category, presence:true
  validates :number, presence:true
  validates :wage_lower_bound, numericality: { greater_than: 0}
  validates :wage_lower_bound, numericality: { less_than: :wage_upper_bound, message: "薪水下限不能高于薪水上限"}
  belongs_to :user
  has_many :resumes

  #投递历史
  has_many :job_relationships
  has_many :members, through: :job_relationships, source: :user

  #收藏
  has_many :job_favorites
  has_many :members, through: :job_favorites, source: :user


  def hide!
    self.is_hidden = true
    self.save
  end

  def publish!
    self.is_hidden = false
    self.save
  end

  scope :published, -> { where(is_hidden: false) }
  scope :recent, -> { order('created_at DESC') }

end
