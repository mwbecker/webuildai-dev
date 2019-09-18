class RanklistElement < ApplicationRecord
  include RailsSortable::Model
  set_sortable :model_rank  # Sort column (should be human rank)
  
  self.table_name = "ranklist_element" # Made a mistake with the table name
  
  # belongs_to :ranklist
  # belongs_to :individual_scenario

  def self.for_ranklist(ranklist_id, rl_size)
    RanklistElement.joins(:individual_scenario).where(ranklist_id: ranklist_id).order(model_rank: :asc).first(rl_size)
  end

  def self.last_ranklist(participant_id=nil)
    if participant_id.nil?
      return RanklistElement.last
    else
      return RanklistElement.order(ranklist_id: :desc).where(participant_id: participant_id).first
    end
  
  end

end