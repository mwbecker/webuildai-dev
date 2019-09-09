class RanklistElement < ApplicationRecord
  self.table_name = "ranklist_element" # Made a mistake with the table name
  



  def self.for_ranklist(ranklist_id, rl_size)
    x = RanklistElement.joins(:individual_scenarios).where(ranklist_id: ranklist_id).order(model_rank: :asc).first(rl_size)
    puts x
    return x
  end

  def self.last_ranklist(participant_id)
    if participant_id.nil?
      return RanklistElement.order(ranklist_id: :desc).first
    else
      return RanklistElement.order(ranklist_id: :desc).where(participant_id: participant_id).first
    end
  
  end

end