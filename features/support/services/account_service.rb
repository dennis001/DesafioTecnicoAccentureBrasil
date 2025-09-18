require_relative '../api_config'

class AccountService
  include HTTParty
  base_uri "#{ApiConfig::BASE_URI}/Account/v1"

  def create_user(user_name, password)
    body = { userName: user_name, password: password }
    self.class.post('/User', body: body.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  def generate_token(user_name, password)
    body = { userName: user_name, password: password }
    self.class.post('/GenerateToken', body: body.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  def authorized?(user_name, password)
    body = { userName: user_name, password: password }
    self.class.post('/Authorized', body: body.to_json, headers: { 'Content-Type' => 'application/json' })
  end
  
  def get_user_details(user_id, token)
    self.class.get(
      "/User/#{user_id}",
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{token}"
      }
    )
  end
end