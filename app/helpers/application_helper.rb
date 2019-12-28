module ApplicationHelper
  def user_display_name(user)
    match = user.email.match(/\A(.*)@/)
    "[#{match.captures[0]}]"
  end
end
