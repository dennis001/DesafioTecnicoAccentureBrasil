#language: pt
#utf-8

Funcionalidade: Criação de usuário na API DemoQA
    Como um consumidor da API DemoQA
    Eu quero criar um novo usuário
    Para que eu possa acessar os serviços protegidos da API

      @criar_usuario
  Cenário: Criar um novo usuário com dados válidos
    Dado que desejo criar um novo usuário válido
    Quando eu faço a requisição de criação de usuário
    Então o usuário deve ser criado com sucesso

      @gerar_token
  Cenário: Gerar token de acesso para o último usuário criado
    Quando eu gerar o token de acesso para o último usuário criado
    E receber um token de acesso válido
    Então o usuário deve estar autorizado

      @listar_livros
  Cenário: Listar os livros disponíveis na BookStore
    Dado que eu queira consultar todos os livros disponíveis
    Então devo ver a lista de livros disponíveis

      @reservar_livros
  Cenário: Reservar dois livros para o usuário criado
    Dado que eu queira consultar todos os livros disponíveis
    Quando eu reservar dois livros para o usuário
    E com os livros reservados
    Então devo ver os detalhes do usuário com os livros reservados