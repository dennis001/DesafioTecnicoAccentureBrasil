require_relative '../pages/web_tables_page'

Dado('que estou na página Web Tables do DemoQA') do
  @web_tables = WebTablesPage.new(@browser)
  @web_tables.navigate_to
end

Quando('crio um novo registro válido') do
  @registro = @web_tables.criar_registro_valido
  expect(@web_tables.registro_existe?(@registro)).to be_truthy
end

Quando('edito esse registro') do
  @registro = @web_tables.editar_registro(@registro)
  expect(@web_tables.registro_existe?(@registro)).to be_truthy
end

Quando('deleto esse registro') do
  @web_tables.deletar_registro(@registro)
end

Então('o registro não deve mais estar presente na tabela') do
  expect(@web_tables.registro_existe?(@registro)).to be_falsey
end

Quando('crio {int} registros válidos dinamicamente') do |quantidade|
  @web_tables.selecionar_numero_de_linhas(20) if quantidade > 10
  @registros_criados = []
  max_tentativas = quantidade * 2

  while @registros_criados.size < quantidade && max_tentativas > 0
    registro = @web_tables.criar_registro_valido
    if @web_tables.registro_existe?(registro)
      @registros_criados << registro
      puts "[SUCESSO] Registro criado: #{registro[:email]}"
    else
      puts "[FALHA] Não foi possível criar registro: #{registro[:email]}"
    end
    max_tentativas -= 1
  end

  unless @registros_criados.size == quantidade
    raise "Não foi possível criar #{quantidade} registros válidos após múltiplas tentativas."
  end
end

Quando('deleto todos esses registros') do
  @registros_criados.each do |registro|
    @web_tables.deletar_registro(registro)
    expect(@web_tables.registro_existe?(registro)).to be_falsey
  end
end

Então('nenhum desses registros deve permanecer na tabela') do
  @registros_criados.each do |registro|
    expect(@web_tables.registro_existe?(registro)).to be_falsey
  end
end