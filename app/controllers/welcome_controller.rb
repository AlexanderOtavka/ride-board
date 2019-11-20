class WelcomeController < ApplicationController
  def index
    if user_signed_in?
      if current_user.drives?
        redirect_to driver_root_path
      else
        redirect_to rider_root_path
      end
    end
  end
end
