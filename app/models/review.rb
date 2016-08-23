class Review < ApplicationRecord
  belongs_to :owner, class_name: User.name
  belongs_to :recipient, class_name: User.name
  belongs_to :invoice

  enum review_type: [:review, :report]
end
