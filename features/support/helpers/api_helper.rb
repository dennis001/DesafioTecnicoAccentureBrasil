require_relative '../api_config'

module ApiHelper
  include HTTParty
  base_uri ApiConfig::BASE_URI

  def get_resource(path, options = {})
    self.class.get(path, options)
  end

  def post_resource(path, body = {}, headers = {})
    self.class.post(path, body: body.to_json, headers: headers)
  end

  # Adicione métodos para PUT, DELETE, etc, se necessário
end

World(ApiHelper)