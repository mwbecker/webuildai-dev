class Feature < ApplicationRecord
  has_many :scenarios
  has_one :data_range
  has_many :categorical_data_options, through: :data_range
  has_many :participant_feature_weights

  scope :active, -> {where(active:true)}
  scope :request, -> {where(category:"request")}
  scope :driver, -> {where(category:"driver")}


  def self.for_user(user_id)
    feats = Array.new
    joins(:participant_feature_weights).where("participant_feature_weights.weight > 0 AND participant_feature_weights.participant_id = ?", user_id).each do |f|
       feats << f
    end
    return feats
  end

end
