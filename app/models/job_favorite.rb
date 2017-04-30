# == Schema Information
#
# Table name: job_favorites
#
#  id         :integer          not null, primary key
#  job_id     :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class JobFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :job
end
