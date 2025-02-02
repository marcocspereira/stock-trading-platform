module AuthHelper
  def auth_headers(user)
    {
      "Authorization" => "Basic #{Base64.strict_encode64("#{user.username}:#{user.password}")}"
    }
  end
end
