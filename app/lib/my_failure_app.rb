# app/lib/my_failure_app.rb
class MyFailureApp < Devise::FailureApp
  def route(*)
    :new_user_registration_url
  end
end
