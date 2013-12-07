class StaticPagesController < ApplicationController
  def home
    if signed_in?
	  if current_user.admin?
	    redirect_to user_activities_path(current_user)
	  else
	    redirect_to current_user	  
	  end
	end
  end
end
