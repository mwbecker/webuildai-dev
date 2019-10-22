# frozen_string_literal: true

module Api
  module V1
    class FeaturesController < ApplicationController
      # TODO: remove this
      skip_before_action :verify_authenticity_token
      before_action :check_login

      def get_all_features
        category = params[:category]
        features = Feature.active.where(category: category).added_by(current_user.id).group_by(&:description).to_a.sort
        result = Hash.new
        features.each do |description, feats|
          result[description] = feats.map{|feature| {id: feature.id, name: feature.name, weight: 0} }
        end
        render json: { features_by_description: result }.to_json
      end

      def get_all_features_shuffled
        category = params[:category]
        features = Feature.active.where(category: category).added_by(current_user.id).group_by(&:description).to_a.shuffle
        result = Hash.new
        features.each do |description, feats|
          result[description] = feats.map{|feature| {id: feature.id, name: feature.name, icon: feature.icon, weight: 0} }
        end
        render json: { features_by_description: result }.to_json
      end


    def make_weight(fid, weight, category)
      pid = current_user.id
      method = category == "request" ? 'how_you' : 'how_ai'
      if ParticipantFeatureWeight.where('participant_id = ? AND feature_id = ? AND method = ?', pid, fid, method).empty?
        @participant_feature_weight = ParticipantFeatureWeight.new
        @participant_feature_weight.participant_id = pid
        @participant_feature_weight.feature_id = fid
        @participant_feature_weight.weight = weight
        @participant_feature_weight.method = method
        @participant_feature_weight.save!

      else
        @participant_feature_weight = ParticipantFeatureWeight.where('participant_id = ? AND feature_id = ? AND method = ?', pid, fid, method).first
        @participant_feature_weight.weight = weight
        @participant_feature_weight.method = method
        @participant_feature_weight.save!
      end
      puts @participant_feature_weight.inspect
    end

    def new_weight
      fid = params[:feature_id].to_i
      weight =  params[:weight].to_i
      make_weight(fid, weight, params[:category])
    end

    def new_feature
        name = params[:name]
        cat = params[:cat]
        weight = params[:weight]
        category = params[:category]
        # continuous feature creation code
        if cat.to_i == 0
          lower = params[:lower]
          upper = params[:upper]
          if Feature.where(name: name).empty?
            a = Feature.create(name: name)
            a.description = params[:description]
            if params[:description].blank?
              a.description = 'Your Own Feature(s) - Continuous'
              a.added_by = current_user.id
              a.company = true if params[:company] == 'true'
            end
            a.active = true
            a.category = params[:category]
            a.unit = params[:unit]
            a.icon = params[:icon]
            a.save!
            DataRange.create(feature_id: a.id, is_categorical: false, lower_bound: lower.to_i, upper_bound: upper.to_i)
          else
            a = Feature.where(name: name).first
            a.description = params[:description]
            if params[:description].blank?
              a.description = 'Your Own Feature(s) - Continuous'
              a.added_by = current_user.id
              a.company = true if params[:company] == 'true'
            end
            a.active = true
            a.category = params[:category]
            a.unit = params[:unit]
            a.icon = params[:icon]
            a.save!
            d = a.data_range
            if !d.nil?
              unless d.categorical_data_options.empty?
                d.categorical_data_options.each(&:destroy!)
              end
              d.lower_bound = lower.to_i
              d.upper_bound = upper.to_i
              d.is_categorical = false
              d.save!
            else
              DataRange.create(feature_id: a.id, is_categorical: false, lower_bound: lower.to_i, upper_bound: upper.to_i)
            end
          end
        else
          puts "making categorical feature"
          puts params
          opts = params[:opts].split('*')
          if Feature.where(name: name).empty?
            a = Feature.create(name: name)
            a.category = params[:category]
            a.icon = params[:icon]
            a.description = params[:description]
            if params[:description].blank?
              a.description = 'Your Own Feature(s) - Categorical'
              a.added_by = current_user.id
              a.company = true if params[:company] == 'true'
            end
            a.active = true
            a.save!
            rng = DataRange.create(feature_id: a.id, is_categorical: true, lower_bound: nil, upper_bound: nil)
            opts.each do |o|
              CategoricalDataOption.create(data_range_id: rng.id, option_value: o)
            end
          else
            a = Feature.where(name: name).first
            a.description = params[:description]
            if params[:description].blank?
              a.description = 'Your Own Feature(s) - Categorical'
              a.added_by = current_user.id
              a.company = true if params[:company] == 'true'
            end
            a.active = true
            a.category = params[:category]
            a.save!
            d = a.data_range
            if !d.nil?
              unless d.categorical_data_options.empty?
                d.categorical_data_options.each(&:destroy!)
              end
              d.lower_bound = nil
              d.upper_bound = nil
              d.is_categorical = true
              d.save!
            else
              d = DataRange.create(feature_id: a.id, is_categorical: true, lower_bound: nil, upper_bound: nil)
            end

            params[:opts].split('*').each do |o|
              CategoricalDataOption.create(data_range_id: d.id, option_value: o)
            end

          end
        end
        puts 'new feature and weight'
        puts a.id
        puts weight
        puts category
        make_weight(a.id, weight, category)
        render json: { id: a.id}.to_json
      end

    end
  end
end