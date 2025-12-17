#!/bin/bash

# setup_vim.sh - Автоматическая установка Vim конфигурации

set -e  # Выход при ошибке

echo "========================================"
echo "   Установка Vim конфигурации"
echo "========================================"

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

# Проверка зависимостей
check_dependencies() {
    print_step "Проверка зависимостей..."
    
    # Проверяем Vim
    if ! command -v vim &> /dev/null; then
        print_error "Vim не установлен!"
        exit 1
    fi
    
    # Проверяем версию Vim
    VIM_VERSION=$(vim --version | head -1 | grep -o '[0-9]\+\.[0-9]\+')
    if [ $(echo "$VIM_VERSION < 9.0" | bc) -eq 1 ]; then
        print_warning "Версия Vim $VIM_VERSION. Рекомендуется 9.0+"
    fi
    
    print_step "Vim $VIM_VERSION обнаружен"
}

# Установка pipx
install_pipx() {
    print_step "Установка pipx..."
    
    if ! command -v pipx &> /dev/null; then
        # Ubuntu/Debian
        if command -v apt &> /dev/null; then
            sudo apt install -y pipx
            pipx ensurepath
        # CentOS/Fedora/RHEL
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y pipx
            pipx ensurepath
        # macOS
        elif command -v brew &> /dev/null; then
            brew install pipx
            pipx ensurepath
        else
            python3 -m pip install --user pipx
            python3 -m pipx ensurepath
        fi
    else
        print_step "pipx уже установлен"
    fi
}

# Установка Python инструментов через pipx
install_python_tools() {
    print_step "Установка Python инструментов через pipx..."
    
    # Black - форматировщик Python
    pipx install black
    
    # Flake8 - линтер Python
    pipx install flake8
    
    # isort - сортировка импортов
    pipx install isort
    
    # yamllint - линтер YAML
    pipx install yamllint
}

# Установка Node.js инструментов
install_node_tools() {
    print_step "Установка Node.js инструментов..."
    
    # Проверяем Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js не установлен!"
        exit 1
    fi
    
    # Prettier - форматировщик JS/TS/HTML/CSS/YAML
    npm install -g prettier
    
    # ESLint - линтер JS/TS
    npm install -g eslint
    
    # HTMLHint - линтер HTML
    npm install -g htmlhint
    
    # TypeScript
    npm install -g typescript
}

# Установка Go инструментов
install_go_tools() {
    print_step "Установка Go инструментов..."
    
    if ! command -v go &> /dev/null; then
        print_warning "Go не установлен, пропускаем..."
        return
    fi
    
    # gopls - Go Language Server
    go install golang.org/x/tools/gopls@latest
    
    # goimports
    go install golang.org/x/tools/cmd/goimports@latest
    
    # staticcheck
    go install honnef.co/go/tools/cmd/staticcheck@latest
    
    # Другие полезные инструменты
    go install github.com/go-delve/delve/cmd/dlv@latest
    go install github.com/fatih/gomodifytags@latest
}

# Установка vim-plug (менеджер плагинов)
install_vim_plug() {
    print_step "Установка vim-plug..."
    
    PLUG_PATH="$HOME/.vim/autoload/plug.vim"
    
    if [ ! -f "$PLUG_PATH" ]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    else
        print_step "vim-plug уже установлен"
    fi
}

# Копирование конфигурации
copy_vim_config() {
    print_step "Копирование конфигурации Vim..."
    
    # Создаем необходимые директории
    mkdir -p ~/.vim/plugged
    mkdir -p ~/.vim/backups
    mkdir -p ~/.vim/swaps
    mkdir -p ~/.vim/undos
    
    # Копируем .vimrc
    if [ -f .vimrc ]; then
        cp .vimrc ~/.vimrc
        print_step "Конфигурация скопирована в ~/.vimrc"
    else
        print_error "Файл .vimrc не найден в текущей директории!"
        exit 1
    fi
}

# Установка плагинов Vim
install_vim_plugins() {
    print_step "Установка плагинов Vim..."
    
    vim +PlugInstall +qall
    
    # Для vim-go нужно установить бинарные файлы
    vim +GoInstallBinaries +qall
}

# Настройка ALE (линтер)
setup_ale() {
    print_step "Настройка ALE..."
    
    # Создаем конфигурационный файл для ALE
    mkdir -p ~/.vim/ale_config
    
    cat > ~/.vim/ale_config/README.md << 'EOF'
# ALE Configuration

Установленные инструменты:
- Python: black, flake8 (через pipx)
- JavaScript/TypeScript: eslint, prettier (через npm)
- Go: gopls (через go install)
- HTML: htmlhint (через npm)
- YAML: yamllint (через pipx)

Проверка установки:
:CheckPlugins
:ALEInfo
EOF
}

# Создание тестовых файлов для проверки
create_test_files() {
    print_step "Создание тестовых файлов..."
    
    mkdir -p ~/vim_test
    
    # Python тестовый файл
    cat > ~/vim_test/test.py << 'EOF'
def test_function():
"""Test function with bad formatting"""
x=1
y=2
return x+y

print(test_function())
EOF

    # JavaScript тестовый файл
    cat > ~/vim_test/test.js << 'EOF'
function test() {
console.log('bad formatting')
return 1+2
}
EOF

    # Go тестовый файл
    cat > ~/vim_test/test.go << 'EOF'
package main

import "fmt"

func main() {
fmt.Println("Hello World")
}
EOF

    print_step "Тестовые файлы созданы в ~/vim_test/"
}

# Финальная проверка
final_check() {
    print_step "\n========================================"
    print_step "    УСТАНОВКА ЗАВЕРШЕНА!"
    print_step "========================================"
    
    echo -e "\n${GREEN}✅ Установлено:${NC}"
    echo "  • Vim с конфигурацией"
    echo "  • pipx для Python инструментов"
    echo "  • Black, Flake8, yamllint"
    echo "  • Prettier, ESLint, htmlhint"
    echo "  • Go инструменты (gopls, goimports)"
    echo "  • Плагины Vim через vim-plug"
    
    echo -e "\n${YELLOW}🔄 Что проверить:${NC}"
    echo "  1. Перезапустите терминал"
    echo "  2. Откройте тестовый файл: vim ~/vim_test/test.py"
    echo "  3. Нажмите Space + w для форматирования"
    echo "  4. Проверьте ALE: :ALEInfo"
    echo "  5. Проверьте Go: откройте .go файл и нажмите F5"
    
    echo -e "\n${GREEN}📝 Горячие клавиши:${NC}"
    echo "  Space + w    - Форматировать и сохранить"
    echo "  Space + n    - Показать/скрыть NERDTree"
    echo "  Space + r    - Запустить Go программу (в .go файле)"
    echo "  Space + an   - Следующая ошибка ALE"
    echo "  Space + ap   - Предыдущая ошибка ALE"
    echo "  F5           - Запуск Go программы"
    echo "  F6           - Сборка Go программы"
    echo "  F7           - Тесты Go"
}

# Главная функция
main() {
    echo "========================================"
    echo "   Начинаем установку..."
    echo "========================================"
    
    check_dependencies
    install_pipx
    install_python_tools
    install_node_tools
    install_go_tools
    install_vim_plug
    copy_vim_config
    install_vim_plugins
    setup_ale
    create_test_files
    final_check
    
    echo -e "\n${GREEN}🎉 Готово! Установка завершена успешно!${NC}"
}

# Запуск скрипта
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
