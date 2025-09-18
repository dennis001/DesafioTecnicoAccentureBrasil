#language: pt
#utf-8

Funcionalidade: Gerenciar registros na Web Tables do DemoQA
    Eu quero criar, editar e deletar registros na Web Tables
    Para manter os dados atualizados e corretos

  Contexto:
    Dado que estou na página Web Tables do DemoQA

  @basic
  Cenário: Criar, editar e deletar um registro
    Quando crio um novo registro válido
    E edito esse registro
    E deleto esse registro
    Então o registro não deve mais estar presente na tabela

  @bonus
  Cenário: Criar e deletar múltiplos registros dinamicamente
    Quando crio 12 registros válidos dinamicamente
    E deleto todos esses registros
    Então nenhum desses registros deve permanecer na tabela