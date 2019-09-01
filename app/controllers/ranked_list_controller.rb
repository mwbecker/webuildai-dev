class RankedListController < ApplicationController
  # Randomly generate examples for ranked list
  def ranked_list
    # Get all features user selected as important
    selectedFeats = Feature.request.active.added_by(current_user.id).for_user(current_user.id)
    @selectedFeats = selectedFeats
    # selectedFeats = Feature.request.active.added_by(3).for_user(3)
    # Size of the Ranked List 
    rankedListSize = 3
    @rankedListScenarios = Array.new
    @rankedListExamples = Array.new
    counter = 0

    # Randomly generate values for features 
    rankedListSize.times do
      three_feats = selectedFeats.sample(selectedFeats.size)

      if !Scenario.all.empty?
        last_id = Scenario.all.last.group_id + 1
      else
        last_id = 1
      end
      three_feats.each do |feat|
        if feat.data_range == nil
        end
        if feat.data_range.is_categorical
          @rankedListScenarios << Scenario.create(group_id: last_id, feature_id: feat.id, feature_value: feat.categorical_data_options.sample.option_value)
        else
          @rankedListScenarios << Scenario.create(group_id: last_id, feature_id: feat.id, feature_value: ((rand(feat.data_range.lower_bound...feat.data_range.upper_bound) * 1).floor / 1.0).to_i.to_s)
        end
      end
      @rankedListExamples << Scenario.where(group_id: last_id)
    end
  end
end
