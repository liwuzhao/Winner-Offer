class Resume < ApplicationRecord
  belongs_to :job
  belongs_to :user

  validates :content, presence: true
  mount_uploader :attachment, AttachmentUploader

  scope :recent, -> { order('created_at DESC') }
end
