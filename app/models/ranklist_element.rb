class RanklistElement < ApplicationRecord
  include RailsSortable::Model
  set_sortable :human_rank  # Sort column

  self.table_name = "ranklist_element" # Made a mistake with the table name

  def self.for_ranklist(ranklist_id, rl_size)
    RanklistElement.joins(:individual_scenarios).where(ranklist_id: ranklist_id).order(model_rank: :asc).first(rl_size)
  end

  def self.last_ranklist(participant_id=nil)
    if participant_id.nil?
      return RanklistElement.order(ranklist_id: :desc).first
    else
      return RanklistElement.order(ranklist_id: :desc).where(participant_id: participant_id).first
    end
  
  end

end