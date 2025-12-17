# learn-go
# Установка Vim (версия 9.0+)
# Ubuntu/Debian
sudo apt update
sudo apt install vim-gtk3 python3-pip nodejs npm

# CentOS/RHEL/Fedora
sudo dnf install vim-enhanced python3-pip nodejs npm

# macOS с Homebrew
brew install vim
brew install python node

# Установка pipx (альтернатива pip)
# Ubuntu/Debian
sudo apt install pipx
pipx ensurepath

# CentOS/RHEL/Fedora
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# macOS
brew install pipx
pipx ensurepath

# После установки перезапустите терминал или выполните:
source ~/.bashrc

# 🚀 Моя Vim Конфигурация

Профессиональная конфигурация Vim для разработки на Go, Python, JavaScript, TypeScript, HTML и YAML.

## ✨ Особенности

- ✅ Автодополнение и LSP через ALE
- ✅ Автоформатирование (Black, Prettier, goimports)
- ✅ Проверка синтаксиса в реальном времени
- ✅ Дерево проекта (NERDTree)
- ✅ Терминал внутри Vim
- ✅ Автосохранение
- ✅ Горячие клавиши для разработки

## 📦 Установка на новую машину

### Способ 1: Автоматически (рекомендуется)

1. Скопируйте файлы на новую машину:
```bash
# Скопируйте .vimrc и setup_vim.sh
scp .vimrc setup_vim.sh user@new-machine:~

Способ 2: Вручную

Следуйте шагам из Manual_Setup_Guide.md

## Ручная настройка (если нужно)

Установка недостающих инструментов

# Python инструменты через pipx
pipx install black
pipx install flake8
pipx install yamllint

# Node.js инструменты
npm install -g prettier
npm install -g eslint
npm install -g htmlhint

# Go инструменты
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest

# Плагины Vim
:PlugInstall
:GoInstallBinaries


