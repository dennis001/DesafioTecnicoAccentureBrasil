Dado('que estou na página Progress Bar do DemoQA') do
  @progress_bar = ProgressBarPage.new(@browser)
  @progress_bar.navegar_ate_progress_bar
end

Quando('inicio a barra de progresso') do
  @progress_bar.iniciar_ou_parar_barra
end

Quando('paro a barra antes de atingir 25%') do
  Watir::Wait.until(timeout: 10) { @progress_bar.valor_atual >= 20 }
  @progress_bar.iniciar_ou_parar_barra
end

Então('o valor da barra deve ser menor ou igual a 25%') do
#   expect(@progress_bar.valor_atual).to be <= 25
    valor = @progress_bar.valor_atual
    expect(valor).to be <= 25, "Valor da barra foi #{valor}%, acima do esperado"
end