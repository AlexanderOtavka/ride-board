class ApplicationController < ActionController::Base
  # The callback which stores the current location must be added before you
  # authenticate the user as `authenticate_user!` (or whatever your resource
  # is) will halt the filter chain and redirect before the location can be
  # stored.
  before_action :store_user_location!, if: :storable_location?

  def authorize_admin!
    unless current_user.admin?
      render_unauthorized
    end
  end

  def render_unauthorized
    render file: "public/401.html", status: :unauthorized
  end

  private
    # Its important that the location is NOT stored if:
    # - The request method is not GET (non idempotent)
    # - The request is handled by a Devise controller such as
    #   Devise::SessionsController as that could cause an infinite redirect loop.
    # - The request is an Ajax request as this can lead to very unexpected behavior.
    def storable_location?
      request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
    end

    def store_user_location!
      # :user is the scope we user for devise. Devise will automatically try to
      # come back to this path after doing authentication
      store_location_for(:user, request.fullpath)
    end
end
