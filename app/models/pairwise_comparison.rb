class PairwiseComparison < ApplicationRecord
  belongs_to :participant

  scope :chronological, -> { order('created_at') }
  
end
