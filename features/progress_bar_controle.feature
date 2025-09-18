#language: pt
#utf-8

Funcionalidade: Controle da Progress Bar no DemoQA
    Eu quero iniciar e parar a barra de progresso
    Para verificar se o controle funciona corretamente

  Cenário: Parar a barra de progresso antes dos 25%
    Dado que estou na página Progress Bar do DemoQA
    Quando inicio a barra de progresso
    E paro a barra antes de atingir 25%
    Então o valor da barra deve ser menor ou igual a 25%