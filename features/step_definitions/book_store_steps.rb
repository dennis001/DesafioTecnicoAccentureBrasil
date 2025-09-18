Dado('que eu queira consultar todos os livros disponíveis') do
  @books_response = BookStoreService.new.list_books
  @books = @books_response['books']
end

Então('devo ver a lista de livros disponíveis') do
  expect(@books_response.code).to eq(200)
  @books = @books_response['books']
  expect(@books).not_to be_empty
  puts "Livros disponíveis:"
  @books.each { |book| puts "#{book['title']} (ISBN: #{book['isbn']})" }
end

Quando('eu reservar dois livros para o usuário') do
  # Garante que temos livros, usuário, token e user_id
  step 'que eu queira consultar todos os livros disponíveis' unless @books
  step 'eu gerar o token de acesso para o último usuário criado' unless @token && @user_id

  # Seleciona dois livros
  isbns = @books.first(2).map { |book| book['isbn'] }
  @reserve_response = BookStoreService.new.add_books(@user_id, isbns, @token)
  @reserved_isbns = isbns
end

Quando('com os livros reservados') do
  expect(@reserve_response.code).to eq(201)
  puts "Livros reservados para o usuário #{@user_id}: #{@reserved_isbns.join(', ')}"
end

Então('devo ver os detalhes do usuário com os livros reservados') do
  @user_details_response = AccountService.new.get_user_details(@user_id, @token)
  expect(@user_details_response.code).to eq(200)
  user_name = @user_details_response['username']
  user_books = @user_details_response['books']
  expect(user_books).not_to be_empty
  puts "Usuário: #{user_name} (ID: #{@user_id})"
  puts "Livros reservados:"
  user_books.each { |book| puts "#{book['title']} (ISBN: #{book['isbn']})" }
end