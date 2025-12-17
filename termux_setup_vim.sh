#!/bin/bash

# setup_vim.sh - Автоматическая установка Vim конфигурации (с поддержкой Termux)

set -e  # Выход при ошибке

echo "========================================"
echo "   Установка Vim конфигурации"
echo "========================================"

# Определяем ОС
if [ -d "/data/data/com.termux" ]; then
    IS_TERMUX=true
    echo "[📱] Обнаружен Termux (Android)"
else
    IS_TERMUX=false
fi

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Проверка Termux и обновление пакетов
update_packages() {
    print_step "Обновление пакетов..."
    
    if [ "$IS_TERMUX" = true ]; then
        pkg update -y && pkg upgrade -y
    else
        # Linux
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt upgrade -y
        elif command -v dnf &> /dev/null; then
            sudo dnf update -y
        elif command -v pacman &> /dev/null; then
            sudo pacman -Syu --noconfirm
        elif command -v brew &> /dev/null; then
            brew update && brew upgrade
        fi
    fi
}

# Проверка зависимостей
check_dependencies() {
    print_step "Проверка зависимостей..."
    
    # Проверяем Vim
    if ! command -v vim &> /dev/null; then
        print_warning "Vim не установлен, устанавливаем..."
        install_vim
    fi
    
    # Проверяем версию Vim
    VIM_VERSION=$(vim --version | head -1 | grep -o '[0-9]\+\.[0-9]\+' || echo "0")
    if [ $(echo "$VIM_VERSION < 8.2" | bc 2>/dev/null || echo "1") -eq 1 ]; then
        print_warning "Версия Vim $VIM_VERSION. Рекомендуется 8.2+"
        if [ "$IS_TERMUX" = false ]; then
            print_info "Для Termux это нормальная версия"
        fi
    else
        print_step "Vim $VIM_VERSION обнаружен"
    fi
}

# Установка Vim
install_vim() {
    if [ "$IS_TERMUX" = true ]; then
        pkg install vim-python -y
    else
        # Linux
        if command -v apt &> /dev/null; then
            sudo apt install -y vim
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y vim-enhanced
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm vim
        elif command -v brew &> /dev/null; then
            brew install vim
        fi
    fi
}

# Установка pipx (для Linux/macOS) или pip (для Termux)
install_python_package_manager() {
    print_step "Установка менеджера Python пакетов..."
    
    if [ "$IS_TERMUX" = true ]; then
        # Termux использует pip напрямую
        print_info "Termux: используем pip вместо pipx"
        pkg install python -y
        pip install --upgrade pip
        
        # Устанавливаем необходимые инструменты через pip
        install_python_tools_termux
    else
        # Linux/macOS - используем pipx
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
        
        install_python_tools
    fi
}

# Установка Python инструментов через pipx (Linux/macOS)
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
    
    # pyright - LSP для Python
    pipx install pyright
}

# Установка Python инструментов для Termux
install_python_tools_termux() {
    print_step "Установка Python инструментов для Termux..."
    
    # В Termux устанавливаем через pip
    pip install black
    pip install flake8
    pip install isort
    pip install yamllint
    pip install python-lsp-server
    
    print_info "В Termux pyright может работать медленно"
    print_info "Рекомендуется использовать python-lsp-server"
}

# Установка Node.js инструментов
install_node_tools() {
    print_step "Установка Node.js инструментов..."
    
    # Проверяем Node.js
    if ! command -v node &> /dev/null; then
        print_warning "Node.js не установлен, устанавливаем..."
        
        if [ "$IS_TERMUX" = true ]; then
            pkg install nodejs-lts -y
        else
            # Linux/macOS
            if command -v apt &> /dev/null; then
                sudo apt install -y nodejs npm
            elif command -v dnf &> /dev/null; then
                sudo dnf install -y nodejs npm
            elif command -v pacman &> /dev/null; then
                sudo pacman -S --noconfirm nodejs npm
            elif command -v brew &> /dev/null; then
                brew install node
            fi
        fi
    fi
    
    # Prettier - форматировщик JS/TS/HTML/CSS/YAML
    npm install -g prettier
    
    # Для Termux устанавливаем дополнительные пакеты
    if [ "$IS_TERMUX" = true ]; then
        # ESLint может быть тяжелым для Termux
        print_info "Termux: устанавливаем облегченный ESLint"
        npm install -g eslint@lite
        
        # HTMLHint
        npm install -g htmlhint
        
        # TypeScript
        npm install -g typescript
    else
        # Полная установка для Linux/macOS
        npm install -g eslint
        npm install -g htmlhint
        npm install -g typescript
        npm install -g typescript-language-server
    fi
}

# Установка Go инструментов
install_go_tools() {
    print_step "Установка Go инструментов..."
    
    if ! command -v go &> /dev/null; then
        print_warning "Go не установлен"
        
        if [ "$IS_TERMUX" = true ]; then
            print_info "Termux: Go доступен через pkg install golang"
            read -p "Установить Go? (y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                pkg install golang -y
            else
                print_info "Пропускаем установку Go"
                return
            fi
        else
            print_info "Для установки Go посетите: https://golang.org/dl/"
            print_info "Пропускаем установку Go"
            return
        fi
    fi
    
    # gopls - Go Language Server
    go install golang.org/x/tools/gopls@latest
    
    # goimports
    go install golang.org/x/tools/cmd/goimports@latest
    
    # Для Termux устанавливаем только основные инструменты
    if [ "$IS_TERMUX" = false ]; then
        # Дополнительные инструменты для Linux/macOS
        go install honnef.co/go/tools/cmd/staticcheck@latest
        go install github.com/go-delve/delve/cmd/dlv@latest
        go install github.com/fatih/gomodifytags@latest
    fi
}

# Установка vim-plug (менеджер плагинов)
install_vim_plug() {
    print_step "Установка vim-plug..."
    
    if [ "$IS_TERMUX" = true ]; then
        # Termux хранит файлы в ~/.vim
        PLUG_PATH="$HOME/.vim/autoload/plug.vim"
    else
        PLUG_PATH="$HOME/.vim/autoload/plug.vim"
    fi
    
    if [ ! -f "$PLUG_PATH" ]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        
        # Для Termux добавляем разрешение на выполнение
        if [ "$IS_TERMUX" = true ]; then
            chmod +x ~/.vim/autoload/plug.vim
        fi
    else
        print_step "vim-plug уже установлен"
    fi
}

# Копирование конфигурации с учетом Termux
copy_vim_config() {
    print_step "Копирование конфигурации Vim..."
    
    # Создаем необходимые директории
    mkdir -p ~/.vim/plugged
    mkdir -p ~/.vim/backups
    mkdir -p ~/.vim/swaps
    mkdir -p ~/.vim/undos
    
    # Копируем .vimrc или создаем новый с учетом Termux
    if [ -f .vimrc ]; then
        # Создаем адаптированную версию для Termux
        if [ "$IS_TERMUX" = true ]; then
            create_termux_vimrc
        else
            cp .vimrc ~/.vimrc
        fi
        print_step "Конфигурация скопирована в ~/.vimrc"
    else
        print_error "Файл .vimrc не найден в текущей директории!"
        exit 1
    fi
}

# Создание адаптированного .vimrc для Termux
create_termux_vimrc() {
    print_info "Создаем адаптированный .vimrc для Termux..."
    
    cat > ~/.vimrc << 'TERMUX_VIMRC'
" === VIM ДЛЯ TERMUX (ANDROID) ===
" Адаптированная версия для мобильной разработки
let mapleader = " "

" ================= ПЛАГИНЫ =================
call plug#begin('~/.vim/plugged')

" Обязательные плагины для Termux
Plug 'jiangmiao/auto-pairs'                           " Автоскобки
Plug 'preservim/nerdtree'                             " Дерево проекта
Plug 'sheerun/vim-polyglot'                           " Подсветка языков

" Для Termux используем более легкие альтернативы
Plug 'dense-analysis/ale'                             " Линтинг (легче чем LSP)
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }   " Go поддержка

call plug#end()

" ================= БАЗОВЫЕ НАСТРОЙКИ TERMUX =================
set number
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set mouse=a
syntax on

" Termux clipboard
if has('termux')
    set clipboard=unnamed
endif

set ignorecase
set smartcase
set hlsearch
set incsearch

" Цветовая схема для Termux
try
    colorscheme desert
catch
    colorscheme default
endtry

set background=dark
set colorcolumn=80
highlight ColorColumn ctermbg=darkgray
set backspace=indent,eol,start
set history=1000
set showcmd
set laststatus=2
set encoding=utf-8
set fileencoding=utf-8
set signcolumn=yes
filetype plugin on
filetype indent on

" ================= GO =================
let g:go_code_completion_enabled = 1
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 0  " Отключаем для производительности в Termux

" ================= ALE ДЛЯ TERMUX =================
let g:ale_enabled = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_text_changed = 'never'  " Для производительности
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save = 1

" Более легкие линтеры для Termux
let g:ale_linters = {
\ 'go': ['golangci-lint'],
\ 'python': ['flake8'],
\ 'javascript': ['standard'],
\ 'typescript': ['tsserver'],
\ 'html': [''],
\ 'yaml': ['yamllint'],
\}

let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black'],
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'go': ['gofmt'],
\}

" ================= ГОРЯЧИЕ КЛАВИШИ TERMUX =================
" Используем Ctrl вместо Space для Termux (удобнее на мобильном)
let mapleader = "\<Space>"

" Основные команды
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>

" Форматирование
nnoremap <leader>f :ALEFix<CR>

" Дерево проекта
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

" Буферы
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>

" Окна (удобно для Termux)
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" ================= GO: ГОРЯЧИЕ КЛАВИШИ =================
autocmd FileType go nnoremap <leader>r :!go run %<CR>
autocmd FileType go nnoremap <leader>b :!go build %<CR>
autocmd FileType go nnoremap <leader>t :!go test<CR>

" ================= ТЕРМИНАЛ В TERMUX =================
" В Termux используем внешний терминал
nnoremap <leader>sh :!termux-open --view %<CR>

" ================= АВТОСЕЙВ =================
autocmd FocusLost,BufLeave * silent! update

" ================= РУЧНОЕ ФОРМАТИРОВАНИЕ =================
function! TermuxFormatAndSave()
    let l:current_view = winsaveview()
    
    if &filetype ==# 'go'
        silent! execute '!goimports -w %'
    elseif &filetype ==# 'python'
        if executable('black')
            silent! execute '!black -q %'
        endif
    elseif &filetype ==# 'javascript' || &filetype ==# 'typescript'
        if executable('prettier')
            silent! execute '!prettier --write %'
        endif
    endif
    
    silent! write
    call winrestview(l:current_view)
endfunction

nnoremap <leader>fw :call TermuxFormatAndSave()<CR>

" ================= ДОПОЛНИТЕЛЬНЫЕ НАСТРОЙКИ TERMUX =================
" Увеличиваем историю команд
set history=500

" Отключаем ненужные функции для производительности
set noswapfile
set nobackup
set nowritebackup
set lazyredraw
set ttyfast

" Настройки для маленького экрана
set lines=30
set columns=100

" Показывать больше информации в статусной строке
set ruler
set showmode
set showcmd

" ================= ПРОВЕРКА TERMUX =================
function! CheckTermux()
    if has('termux')
        echo "✅ Работает в Termux"
        echo "📱 Версия Android: " . system('getprop ro.build.version.release')
        echo "💾 Память: " . system('free -h | grep Mem | awk "{print \$2}"')
    else
        echo "❌ Не Termux"
    endif
endfunction
command! CheckTermux call CheckTermux()

" ================= iabbrev =================
iabbrev pkgm package main<CR><CR>func main() {<CR><CR>}<Up><Tab>
iabbrev impt import ""<Left>
iabbrev pfmt fmt.Println("")<Left><Left>
iabbrev errf if err != nil {<CR>log.Fatal(err)<CR>}<Up><Tab>
TERMUX_VIMRC
    
    print_step "Создан адаптированный .vimrc для Termux"
}

# Установка плагинов Vim
install_vim_plugins() {
    print_step "Установка плагинов Vim..."
    
    if [ "$IS_TERMUX" = true ]; then
        print_info "Termux: установка плагинов может занять время..."
        vim +'PlugInstall --sync' +qall 2>/dev/null || true
        
        # Для vim-go нужно установить бинарные файлы
        print_info "Устанавливаем Go бинарные файлы..."
        vim +'GoInstallBinaries' +qall 2>/dev/null || true
    else
        vim +PlugInstall +qall
        vim +GoInstallBinaries +qall
    fi
}

# Специальные настройки для Termux
setup_termux_special() {
    if [ "$IS_TERMUX" = true ]; then
        print_step "Дополнительные настройки для Termux..."
        
        # Разрешаем доступ к хранилищу
        termux-setup-storage
        
        # Устанавливаем дополнительные полезные пакеты
        pkg install termux-api -y
        pkg install git -y
        pkg install openssh -y
        pkg install nano -y
        
        # Создаем удобные алиасы
        echo "alias v='vim'" >> ~/.bashrc
        echo "alias nv='nvim'" >> ~/.bashrc
        echo "alias ..='cd ..'" >> ~/.bashrc
        echo "alias ...='cd ../..'" >> ~/.bashrc
        echo "alias ll='ls -la'" >> ~/.bashrc
        
        # Настраиваем хранилище
        mkdir -p ~/storage/shared/vim-projects
        
        print_info "✅ Termux настроен!"
        print_info "📁 Проекты можно хранить в: ~/storage/shared/vim-projects"
    fi
}

# Настройка ALE (линтер)
setup_ale() {
    print_step "Настройка ALE..."
    
    # Создаем конфигурационный файл для ALE
    mkdir -p ~/.vim/ale_config
    
    cat > ~/.vim/ale_config/README.md << EOF
# ALE Configuration

Установленные инструменты:
- Python: black, flake8 $( [ "$IS_TERMUX" = true ] && echo "(через pip)" || echo "(через pipx)" )
- JavaScript/TypeScript: eslint, prettier (через npm)
- Go: gopls (через go install)
- HTML: htmlhint (через npm)
- YAML: yamllint $( [ "$IS_TERMUX" = true ] && echo "(через pip)" || echo "(через pipx)" )

Проверка установки:
:CheckPlugins
:ALEInfo

$( [ "$IS_TERMUX" = true ] && echo "Версия для Termux (Android)" || echo "Версия для Linux/macOS" )
EOF
}

# Создание тестовых файлов для проверки
create_test_files() {
    print_step "Создание тестовых файлов..."
    
    TEST_DIR="$HOME/vim_test"
    if [ "$IS_TERMUX" = true ]; then
        TEST_DIR="$HOME/storage/shared/vim_test"
        mkdir -p "$TEST_DIR"
    else
        mkdir -p "$TEST_DIR"
    fi
    
    # Python тестовый файл
    cat > "$TEST_DIR/test.py" << 'EOF'
def test_function():
"""Test function with bad formatting"""
x=1
y=2
return x+y

print(test_function())
EOF

    # JavaScript тестовый файл
    cat > "$TEST_DIR/test.js" << 'EOF'
function test() {
console.log('bad formatting')
return 1+2
}
EOF

    # Go тестовый файл
    cat > "$TEST_DIR/test.go" << 'EOF'
package main

import "fmt"

func main() {
fmt.Println("Hello World")
}
EOF

    # HTML тестовый файл
    cat > "$TEST_DIR/test.html" << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Test</title></head>
<body>
<h1>Test</h1>
</body>
</html>
EOF

    print_step "Тестовые файлы созданы в $TEST_DIR/"
}

# Финальная проверка
final_check() {
    print_step "\n========================================"
    print_step "    УСТАНОВКА ЗАВЕРШЕНА!"
    print_step "========================================"
    
    if [ "$IS_TERMUX" = true ]; then
        echo -e "\n${GREEN}✅ Установлено в Termux:${NC}"
        echo "  📱 Vim с адаптированной конфигурацией"
        echo "  🐍 Python с black, flake8"
        echo "  📦 Node.js с prettier"
        echo "  🐹 Go инструменты (если установлен Go)"
        echo "  🔌 Плагины Vim"
        echo "  📂 Доступ к хранилищу"
    else
        echo -e "\n${GREEN}✅ Установлено:${NC}"
        echo "  🖥️  Vim с конфигурацией"
        echo "  📦 pipx для изолированных Python инструментов"
        echo "  🐍 Black, Flake8, yamllint через pipx"
        echo "  📋 Prettier, ESLint, htmlhint через npm"
        echo "  🐹 Go инструменты (gopls, goimports)"
        echo "  🔌 Плагины Vim через vim-plug"
    fi
    
    echo -e "\n${YELLOW}🔄 Что проверить:${NC}"
    echo "  1. Перезапустите терминал"
    echo "  2. Откройте тестовый файл: vim $TEST_DIR/test.py"
    
    if [ "$IS_TERMUX" = true ]; then
        echo "  3. Нажмите Ctrl + f для форматирования"
        echo "  4. Проверьте ALE: :ALEInfo"
        echo "  5. Проверьте Termux: :CheckTermux"
    else
        echo "  3. Нажмите Space + w для форматирования"
        echo "  4. Проверьте ALE: :ALEInfo"
        echo "  5. Проверьте Go: откройте .go файл и нажмите F5"
    fi
    
    echo -e "\n${GREEN}📝 Горячие клавиши:${NC}"
    
    if [ "$IS_TERMUX" = true ]; then
        echo "  Space + w    - Сохранить"
        echo "  Space + f    - Форматировать файл (ALEFix)"
        echo "  Space + n    - Показать/скрыть NERDTree"
        echo "  Space + r    - Запустить Go программу"
        echo "  Ctrl + h/l/j/k - Навигация между окнами"
        echo "  :CheckTermux - Проверить окружение Termux"
    else
        echo "  Space + w    - Форматировать и сохранить"
        echo "  Space + n    - Показать/скрыть NERDTree"
        echo "  Space + r    - Запустить Go программу"
        echo "  Space + an   - Следующая ошибка ALE"
        echo "  Space + ap   - Предыдущая ошибка ALE"
        echo "  F5           - Запуск Go программы"
        echo "  F6           - Сборка Go программы"
        echo "  F7           - Тесты Go"
    fi
    
    if [ "$IS_TERMUX" = true ]; then
        echo -e "\n${BLUE}📱 Советы для Termux:${NC}"
        echo "  • Долгое нажатие клавиш = дополнительные символы"
        echo "  • Свайп влево = клавиатура с Ctrl/Alt/Esc"
        echo "  • termux-setup-storage = доступ к файлам"
        echo "  • Проекты храните в ~/storage/shared/"
    fi
}

# Главная функция
main() {
    echo "========================================"
    echo "   Начинаем установку..."
    echo "========================================"
    
    update_packages
    check_dependencies
    install_python_package_manager
    install_node_tools
    install_go_tools
    install_vim_plug
    copy_vim_config
    install_vim_plugins
    setup_termux_special
    setup_ale
    create_test_files
    final_check
    
    echo -e "\n${GREEN}🎉 Готово! Установка завершена успешно!${NC}"
    
    if [ "$IS_TERMUX" = true ]; then
        echo -e "\n${YELLOW}⚠️  Для Termux перезапустите приложение!${NC}"
        echo "   Или выполните: source ~/.bashrc"
    fi
}

# Запуск скрипта
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
