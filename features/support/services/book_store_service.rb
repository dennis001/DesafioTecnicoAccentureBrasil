require_relative '../api_config'

class BookStoreService
  include HTTParty
  base_uri "#{ApiConfig::BASE_URI}/BookStore/v1"

  def list_books
    self.class.get('/Books')
  end
  def add_books(user_id, isbns, token)
    body = {
        userId: user_id,
        collectionOfIsbns: isbns.map { |isbn| { isbn: isbn } }
    }
    self.class.post(
        '/Books',
        body: body.to_json,
        headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{token}"
        }
    )
    end
end