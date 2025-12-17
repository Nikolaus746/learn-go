
## 📄 Дополнительный файл для ручной установки

Создайте `Manual_Setup_Guide.md`:

```markdown
# 📘 Ручная установка Vim конфигурации

Пошаговое руководство для ручной установки, если автоматический скрипт не работает.

## Шаг 1: Установите Vim 9.0+

### Ubuntu/Debian
```bash
sudo add-apt-repository ppa:jonathonf/vim
sudo apt update
sudo apt install vim-gtk3

### macOS
brew install vim

## Шаг 2: Установите pipx

# Linux
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# Перезагрузите терминал
exec $SHELL

Шаг 3: Установите языковые инструменты

Python

pipx install black
pipx install flake8
pipx install isort
pipx install yamllint

JavaScript/TypeScript

npm install -g prettier
npm install -g eslint
npm install -g htmlhint
npm install -g typescript

Go

go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest

Шаг 4: Установите vim-plug

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

Шаг 5: Скопируйте .vimrc


# Скопируйте ваш .vimrc в домашнюю директорию
cp .vimrc ~/.vimrc

Шаг 6: Установите плагины

:PlugInstall
:GoInstallBinaries

Шаг 7: Проверка

Создайте тестовый файл:

echo 'print("hello"  )' > test.py
vim test.py

В Vim нажмите Space + w - файл должен отформатироваться.
