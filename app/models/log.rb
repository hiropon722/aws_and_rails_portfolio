class Log < ApplicationRecord
    belongs_to :user
    validates :log_message, presence: true
end
  