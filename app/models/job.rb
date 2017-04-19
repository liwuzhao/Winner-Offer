class Job < ApplicationRecord
  validates :title , presence:true
  validates :contact_email, presence:true
  validates :wage_upper_bound, presence:true
  validates :wage_lower_bound, presence:true
  validates :location, presence:true
  validates :company, presence:true
  validates :category, presence:true
  validates :wage_lower_bound, numericality: { greater_than: 0}
  validates :wage_lower_bound, numericality: { less_than: :wage_upper_bound, message: "薪水下限不能高于薪水上限"}
  belongs_to :user
  has_many :resumes

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
