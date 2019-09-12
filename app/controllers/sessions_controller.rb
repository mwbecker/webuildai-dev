class SessionsController < ApplicationController

  def new
   end
   def create
     participant = Participant.authenticate(params[:id], params[:password])
     if participant
       session[:participant_id] = participant.id
       redirect_to new_pairwise_comparison_path, notice: "Logged in!"
     else
       flash.now.alert = "Username and/or password is invalid"
       render "new"
     end
   end
   def destroy
     session[:participant_id] = nil
     session[:about] = false
     redirect_to login_path, notice: "Logged out!"
   end

end
