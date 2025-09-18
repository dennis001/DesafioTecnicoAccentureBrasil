Dado('que desejo criar um novo usuário válido') do
  @user_name = Faker::Internet.unique.username(specifier: 8)
  @password = "Str0ng!#{rand(1000..9999)}"
end

Quando('eu faço a requisição de criação de usuário') do
  @response = AccountService.new.create_user(@user_name, @password)
end

Então('o usuário deve ser criado com sucesso') do
  expect(@response.code).to eq(201)
  @user_id = @response['userID']
  expect(@user_id).not_to be_nil
  puts "Usuário criado com sucesso!"
  puts "userName: #{@user_name}"
  puts "password: #{@password}"
  puts "userID: #{@user_id}"
end

Quando('eu gerar o token de acesso para o último usuário criado') do
  unless @user_name && @password
    step 'que desejo criar um novo usuário válido'
    @response = AccountService.new.create_user(@user_name, @password)
    @user_id = @response['userID']
  end
  @token_response = AccountService.new.generate_token(@user_name, @password)
  @token = @token_response['token']
  @user_id ||= @token_response['userId'] # Garante que @user_id está preenchido
end

Quando('receber um token de acesso válido') do
  expect(@token_response.code).to eq(200)
  @token = @token_response['token']
  expect(@token).not_to be_nil
  puts "Token gerado: #{@token}"
end

Então('o usuário deve estar autorizado') do
  @auth_response = AccountService.new.authorized?(@user_name, @password)
  expect(@auth_response.code).to eq(200)
  expect(@auth_response.parsed_response).to eq(true)
  puts "Usuário autorizado com sucesso!"
end