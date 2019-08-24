class Participant < ApplicationRecord

  has_secure_password

  has_many :pairwise_comparisons
  has_many :participant_feature_weights
  has_many :abouts

  def self.authenticate(id, password)
   find_by_id(id).try(:authenticate, password)
 end

end
