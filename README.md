# Desafio Técnico Accenture Brasil – Automação DemoQA

## Visão Geral

Este projeto entrega uma automação robusta, escalável e multiplataforma para o site [DemoQA](https://demoqa.com/), cobrindo cenários de UI (Web Tables, Progress Bar) e API, com arquitetura baseada em Page Objects, integração com ReportBuilder e execução facilitada tanto localmente quanto em pipelines CI/CD (GitHub Actions).

---

## Pré-requisitos

- **Ruby** >= 2.7 (preferencialmente 3.x)
- **Bundler** >= 2.0
- **Git** para versionamento
- **Google Chrome** (para execução local com interface)
- **Linux (Ubuntu), MacOS ou Windows (WSL/Git Bash recomendado para Windows)**

> **Dica:** O script `setup.sh` automatiza toda a configuração do ambiente, incluindo instalação de dependências Ruby.

---

## Estrutura do Projeto

```
.
├── features/
|   ├── api/
│   │   ├── step_definations/
│   │   |   ├── account_steps.rb
│   │   |   └── book_store_steps.rb
|   |   └── criar_usuario.feature
│   ├── ui/
│   │   ├── pages/
│   │   │   ├── web_tables_page.rb
│   │   │   └── progress_bar_page.rb
│   │   └── step_definations/
│   │       ├── web_tables_steps.rb
│   │       └── progress_bar_steps.rb
│   ├── support/
│   │   ├── helpers/
│   │   │   └── api_helper.rb
│   │   ├── hooks.rb
|   |   ├── env.rb
|   |   ├── api_config.rb
|   |   └── services/
|   |   |   ├── account_service.rb
│   │   │   └── book_store_service.rb
│   ├── web_tables_crud.feature
│   └── progress_bar_controle.feature
├── reports/
│   └── screenshots/
├── setup.sh
├── Rakefile
├── cucumber.yml
├── Gemfile
├── .gitignore
└── README.md
```

- **features/**: Cenários, steps, helpers e Page Objects.
- **reports/**: Relatórios e evidências (não versionados).
- **setup.sh**: Script de configuração automatizada.
- **Rakefile**: Tasks para execução e geração de relatórios.
- **cucumber.yml**: Perfis dinâmicos para execução customizada.

---

## Passo a Passo para Configuração

### 1. Clone o repositório

```sh
git clone https://github.com/dennis001/DesafioTecnicoAccentureBrasil.git
cd DesafioTecnicoAccentureBrasil
```

### 2. Execute o setup automatizado

```sh
./setup.sh
```
O script irá:
- Instalar o Ruby (Ubuntu/MacOS) caso necessário.
- Instalar o Bundler.
- Instalar todas as gems do projeto.
- Validar a estrutura de pastas para relatórios.

### 3. (Opcional) Configure variáveis de ambiente

Você pode customizar a execução usando variáveis como:
- `HEADLESS=true` para rodar sem interface gráfica.
- `BROWSER=chrome` ou `BROWSER=firefox` para escolher o navegador.

---

## Como Executar os Testes

### Execução local

- **Cenários completos com relatório:**
  ```sh
  cucumber -p report
  ```

- **Execução headless:**
  ```sh
  cucumber -p report -p headless
  ```

- **Execução por tags:**
  ```sh
  cucumber -p report -t @bonus
  ```

- **Usando Rake:**
  ```sh
  rake cucumber cucumber_opts="-p report"
  rake report
  ```

### Execução em CI/CD (GitHub Actions)

O arquivo `setup.sh` garante que o ambiente será configurado corretamente no pipeline.  
Basta adicionar os steps de execução no workflow (veja exemplo no final deste README).

---

## Relatórios e Evidências

- Os relatórios HTML e JSON são gerados em `reports/`.
- Prints de falha são salvos em `reports/screenshots/`.
- O ReportBuilder gera um relatório final consolidado em `reports/report_final.html`.

---

## Boas Práticas e Arquitetura

- **Page Objects**: Separação clara entre lógica de teste e mapeamento de elementos.
- **Waits explícitos**: Sem uso de `sleep`, apenas waits robustos.
- **Perfis dinâmicos**: Execução flexível via `cucumber.yml`.
- **Relatórios profissionais**: Evidências automáticas em caso de falha, integração com CI/CD.
- **Código limpo**: Sem prints ou debuggers desnecessários, métodos autoexplicativos.

---

## Exemplo de Workflow para GitHub Actions

```yaml
name: CI - Accenture DemoQA

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

permissions:
  contents: read

jobs:
  test:
    runs-on: ubuntu-latest
    env:
      HEADLESS: "true"  # Garante execução headless em todos os steps

    strategy:
      matrix:
        ruby-version: ['3.2']

    steps:
      - name: Checkout do código
        uses: actions/checkout@v4

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: ${{ matrix.ruby-version }}
          bundler-cache: true

      - name: Instalar dependências (bundle install)
        run: bundle install

      - name: Garante pasta de relatórios
        run: mkdir -p reports

      - name: Executa testes com Cucumber (gera HTML)
        run: bundle exec cucumber -p headless -p report --format html --out reports/relatorio.html || true

      - name: Rerun cenários falhos até 3 vezes (se houver)
        if: always()
        run: |
          tentativas=0
          max_tentativas=3
          while [ -s rerun.txt ] && [ $tentativas -lt $max_tentativas ]; do
            tentativas=$((tentativas+1))
            echo "Tentativa de rerun #$tentativas..."
            cp rerun.txt rerun_tmp.txt
            bundle exec cucumber -p headless @rerun_tmp.txt --format html --out reports/relatorio_rerun_$tentativas.html --format rerun --out rerun.txt || true
          done
          if [ -s rerun.txt ]; then
            echo "Ainda há cenários falhos após $max_tentativas tentativas."
          fi

      - name: Gera relatório final com ReportBuilder
        if: always()
        run: bundle exec rake report

      - name: Upload de evidências e relatórios
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: reports
          path: reports/
```

---