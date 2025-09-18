class WebTablesPage
  include PageObject

  page_url 'https://demoqa.com/webtables'

  button(:add, id: 'addNewRecordButton')
  text_field(:first_name, id: 'firstName')
  text_field(:last_name, id: 'lastName')
  text_field(:email, id: 'userEmail')
  text_field(:age, id: 'age')
  text_field(:salary, id: 'salary')
  text_field(:department, id: 'department')
  button(:submit, id: 'submit')

  def navigate_to
    self.goto
  end

  def criar_registro_valido
    self.browser.execute_script('window.scrollTo(0, 0);')
    add
    registro = gerar_dados_registro
    preencher_formulario(registro)
    submit
    registro
  end

  def editar_registro(registro)
    linha = self.browser.divs(class: 'rt-tr-group').find { |row| row.text.include?(registro[:email]) }
    raise "Registro não encontrado para edição" unless linha

    celula_acoes = celula_acoes_da_linha(linha)
    edit_span = celula_acoes.span(title: 'Edit')
    raise "Botão Edit não encontrado" unless edit_span.exists?

    self.browser.execute_script('arguments[0].scrollIntoView(true);', edit_span)
    edit_span.wait_until(&:present?)
    edit_span.click

    novos_dados = gerar_dados_registro
    preencher_formulario(novos_dados)
    submit
    novos_dados
  end

  def deletar_registro(registro)
    linha = self.browser.divs(class: 'rt-tr-group').find { |row| row.text.include?(registro[:email]) }
    raise "Registro não encontrado para deleção" unless linha

    celula_acoes = celula_acoes_da_linha(linha)
    delete_span = celula_acoes.span(title: 'Delete')
    raise "Botão Delete não encontrado" unless delete_span.exists?

    self.browser.execute_script('arguments[0].scrollIntoView(true);', delete_span)
    delete_span.wait_until(&:present?)
    delete_span.click
  end

  def registro_existe?(registro)
    self.browser.wait_until(timeout: 10) { self.browser.div(class: 'rt-table').exists? }
    self.browser.wait_until(timeout: 10) { self.browser.div(class: 'rt-tr-group').exists? }
    self.browser.divs(class: 'rt-tr-group').any? do |row|
    [
      registro[:first_name],
      registro[:last_name],
      registro[:age],
      registro[:email],
      registro[:salary],
      registro[:department]
    ].all? { |valor| row.text.include?(valor.to_s) }
    end
  end

  def selecionar_numero_de_linhas(qtd)
    dropdown = self.browser.select(css: 'select[aria-label="rows per page"]')
    self.browser.execute_script('arguments[0].scrollIntoView(true);', dropdown)
    dropdown.select(qtd.to_s)
    self.browser.wait_until(timeout: 5) do
      dropdown.value == qtd.to_s
    end
  end

  private

  def gerar_dados_registro
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: "#{Faker::Internet.username}_#{SecureRandom.hex(4)}@#{Faker::Internet.domain_name}.com",
      age: rand(18..65).to_s,
      salary: rand(3000..15000).to_s,
      department: Faker::Company.industry
    }
  end

  def preencher_formulario(dados)
    self.first_name = dados[:first_name]
    self.last_name = dados[:last_name]
    self.email = dados[:email]
    self.age = dados[:age]
    self.salary = dados[:salary]
    self.department = dados[:department]
  end

  def celula_acoes_da_linha(linha)
    linha.divs(class: 'rt-td').last
  end
end