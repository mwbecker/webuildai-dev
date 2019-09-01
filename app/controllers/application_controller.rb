class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  after_action  :set_access_control_headers
  def set_access_control_headers
   headers['Access-Control-Allow-Origin'] = '*'
  end
  private
  # Handling authentication

  helper_method :get_ranges
  helper_method :get_ranges_2
  helper_method :get_ranges_ai
  helper_method :get_ranges_ai_2

  def get_ranges
    to_ret = Array.new
    fs = Feature.active.all.order(:description)
    fs.each do |f|
      to_ret << f.id
    end
    lenth = fs.size-1
    for i in 0..lenth do
      w = ParticipantFeatureWeight.where("participant_id = ? AND feature_id = ? AND method = ?", current_user.id, to_ret[i],"how_you")
      if !w.empty?
        to_ret[i] = w.first.weight
      else
        to_ret[i] = 0
      end
    end
    return to_ret.reverse
  end

  def get_ranges_2
    to_ret = Array.new
    fs = Feature.active.all.order(:description)
    fs.each do |f|
      to_ret << f.id
    end
    lenth = fs.size-1
    for i in 0..lenth do
      w = ParticipantFeatureWeight.where("participant_id = ? AND feature_id = ? AND method = ?", current_user.id, to_ret[i], "how_you")
      if !w.empty?
        to_ret[i] = "0." + ((w.first.weight / 10).floor).to_s if (w.first.weight / 10).floor != 0
        to_ret[i] = 0 if  w.first.weight  == 0
        to_ret[i] = "0.1" if (w.first.weight  > 0 && (w.first.weight / 10).floor == 0)
        to_ret[i] = 1 if  (w.first.weight / 10).floor == 10
      else
        to_ret[i] = 0
      end
    end
    return to_ret.reverse
  end

  def get_ranges_ai
    to_ret = Array.new
    fs = Feature.active.all.order(:description)
    fs.each do |f|
      to_ret << f.id
    end
    lenth = fs.size-1
    for i in 0..lenth do
      w = ParticipantFeatureWeight.where("participant_id = ? AND feature_id = ? AND method = ?", current_user.id, to_ret[i], "how_ai")
      if !w.empty?
        to_ret[i] = w.first.weight
      else
        to_ret[i] = 0
      end
    end
    return to_ret.reverse
  end

  def get_ranges_ai_2
    to_ret = Array.new
    fs = Feature.active.all.order(:description)
    fs.each do |f|
      to_ret << f.id
    end
    lenth = fs.size-1
    for i in 0..lenth do
      w = ParticipantFeatureWeight.where("participant_id = ? AND feature_id = ? AND method = ?", current_user.id, to_ret[i], "how_ai")
      if !w.empty?
        to_ret[i] = "0." + ((w.first.weight / 10).floor).to_s if (w.first.weight / 10).floor != 0
        to_ret[i] = 0 if  w.first.weight  == 0
        to_ret[i] = "0.1" if (w.first.weight  > 0 && (w.first.weight / 10).floor == 0)
        to_ret[i] = 1 if  (w.first.weight / 10).floor == 10
      else
        to_ret[i] = 0
      end
    end
    return to_ret.reverse
  end

  def current_user
    @current_user ||= Participant.find(session[:participant_id]) if session[:participant_id]
  end
  helper_method :current_user
  def logged_in?
    current_user
  end
  helper_method :logged_in?
  def check_login
    redirect_to login_path, alert: "You need to log in to view this page." if current_user.nil?
  end

end
