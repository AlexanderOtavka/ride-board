module ApplicationHelper
  def user_display_name(user)
    match = user.email.match(/\A(.*)@/)
    "[#{match.captures[0]}]"
  end
  def controller_stylesheet(opts = { media: :all })
    if Rails.application.assets.find_asset("#{params[:controller]}.css")
      stylesheet_link_tag(params[:controller], opts)
    end
  end
  def controller_javascript(opts = {})
    if Rails.application.assets.find_asset("#{params[:controller]}.js")
      javascript_include_tag(params[:controller], opts)
    end
  end
end
