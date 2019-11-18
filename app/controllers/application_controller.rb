class ApplicationController < ActionController::Base
  def authorize_admin!
    unless current_user.admin?
      render_unauthorized
    end
  end

  def render_unauthorized
    render file: "public/401.html", status: :unauthorized
  end
end
