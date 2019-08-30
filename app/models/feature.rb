class Feature < ApplicationRecord
  has_many :scenarios
  has_one :data_range
  has_many :categorical_data_options, through: :data_range
  has_many :participant_feature_weights

  scope :active, -> {where(active:true)}
  scope :request, -> {where(category:"request")}
  scope :driver, -> {where(category:"driver")}
  scope :added_by, -> (user_id){where("added_by = ? OR added_by IS NULL", user_id.to_s )}
  scope :company, -> {where(company:true)}
  scope :personal, -> {where(company:false)}

  def self.for_user(user_id)
    feats = Array.new
    joins(:participant_feature_weights).where("participant_feature_weights.method = ? AND participant_feature_weights.weight > 0 AND participant_feature_weights.participant_id = ?", "how_you", user_id).each do |f|
       feats << f
    end
    return feats
  end


end
