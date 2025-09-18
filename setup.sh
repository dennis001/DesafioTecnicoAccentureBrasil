#!/bin/bash

echo "===> Iniciando setup do projeto..."

if ! command -v ruby &> /dev/null; then
  echo "Ruby não encontrado. Tentando instalar Ruby..."

  if [ -f /etc/debian_version ]; then
    sudo apt-get update
    sudo apt-get install -y ruby-full build-essential zlib1g-dev
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &> /dev/null; then
      echo "Homebrew não encontrado. Instale o Homebrew manualmente."
      exit 1
    fi
    brew install ruby
  else
    echo "Sistema operacional não suportado para instalação automática do Ruby."
    echo "Instale o Ruby manualmente e rode novamente o setup."
    exit 1
  fi
fi

if ! gem list bundler -i > /dev/null; then
  echo "Instalando bundler..."
  gem install bundler
fi

echo "Instalando gems do projeto..."
bundle install

echo "Setup concluído! Para rodar os testes, use:"
echo "  cucumber -p report"
echo "Ou utilize o Rakefile: rake cucumber && rake report"