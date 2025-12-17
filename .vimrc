" === VIM 9+ ДЛЯ GO, PYTHON, JS, HTML, YAML ===
let mapleader = " "

" ================= ПЛАГИНЫ =================
call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }   " Go
Plug 'jiangmiao/auto-pairs'                           " Автоскобки
Plug 'preservim/nerdtree'                             " Дерево проекта
Plug 'sheerun/vim-polyglot'                           " Подсветка языков
Plug 'dense-analysis/ale'                             " Ошибки / опечатки
call plug#end()

" ================= БАЗОВЫЕ НАСТРОЙКИ =================
set number
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set mouse=a
syntax on
set clipboard=unnamedplus
set ignorecase
set smartcase
set hlsearch
set incsearch
colorscheme desert
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
let g:go_auto_type_info = 1
let g:go_def_mode = 'gopls'
let g:go_info_mode = 'gopls'

" ================= ALE =================
let g:ale_enabled = 1
let g:ale_lint_on_enter = 1           " Проверять при открытии файла
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1

let g:ale_hover_cursor = 0
let g:ale_echo_cursor = 1
let g:ale_echo_msg_format = '[%linter%] %s'

let g:ale_linters = {
\ 'go': ['gopls'],
\ 'python': ['pyright', 'flake8'],
\ 'javascript': ['eslint'],
\ 'typescript': ['eslint'],
\ 'html': ['htmlhint'],
\ 'yaml': ['yamllint'],
\}

let g:ale_fix_on_save = 0

" Делаем подчёркивания более заметными
highlight ALEError cterm=underline ctermfg=red gui=underline guifg=#ff0000
highlight ALEWarning cterm=underline ctermfg=yellow gui=underline guifg=#ffff00
highlight ALEErrorSign ctermbg=black ctermfg=red
highlight ALEWarningSign ctermbg=black ctermfg=yellow

" ================= GO: ГОРЯЧИЕ КЛАВИШИ =================
autocmd FileType go nnoremap <leader>r :!go run %<CR>
autocmd FileType go nnoremap <leader>b :!go build %<CR>
autocmd FileType go nnoremap <leader>t :!go test<CR>
autocmd FileType go nnoremap <leader>v :!go vet %<CR>
autocmd FileType go nnoremap <F5> :!go run %<CR>
autocmd FileType go nnoremap <F6> :!go build %<CR>
autocmd FileType go nnoremap <F7> :!go test<CR>

" ================= NERDTREE =================
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
" Убрал автоматическое открытие - часто мешает
let g:NERDTreeAutoRefresh = 1
let g:NERDTreeShowHidden = 1

" ================= БУФЕРЫ =================
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>

" ================= ОКНА =================
nnoremap <leader>h <C-w>h
nnoremap <leader>l <C-w>l
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k

" ================= ТЕРМИНАЛ =================
function! TermBelow()
    split
    terminal
    startinsert
endfunction
nnoremap <leader>sh :call TermBelow()<CR>

function! TermRight()
    vsplit
    terminal
    startinsert
endfunction
nnoremap <leader>sv :call TermRight()<CR>

" ================= АВТОСЕЙВ (БЕЗ ФОРМАТА!) =================
autocmd FocusLost,BufLeave * silent! update

function! AutoSave(timer)
    if &modifiable && &modified
        silent! update
    endif
endfunction
call timer_start(60000, 'AutoSave', {'repeat': -1})

" ================= РУЧНОЕ ФОРМАТИРОВАНИЕ =================
function! FormatAndSave()
    let l:current_view = winsaveview()  " Сохраняем позицию курсора
    
    if &filetype ==# 'go'
        silent! call go#fmt#Format(-1)
    elseif &filetype ==# 'python'
        if executable('black')
            silent! execute '%!black -q - 2>/dev/null'
        else
            echo "black не установлен. Установите: pip install black"
        endif
    elseif &filetype ==# 'javascript' || &filetype ==# 'typescript'
        if executable('prettier')
            silent! execute '%!prettier --stdin-filepath % 2>/dev/null'
        else
            echo "prettier не установлен. Установите: npm install -g prettier"
        endif
    elseif &filetype ==# 'html' || &filetype ==# 'yaml'
        if executable('prettier')
            silent! execute '%!prettier --stdin-filepath % 2>/dev/null'
        endif
    endif
    
    silent! write
    call winrestview(l:current_view)  " Восстанавливаем позицию
endfunction

" Space + w = форматировать и сохранить
nnoremap <leader>w :call FormatAndSave()<CR>

" Горячие клавиши ALE
nnoremap <leader>an :ALENext<CR>
nnoremap <leader>ap :ALEPrevious<CR>
nnoremap <leader>ad :ALEDetail<CR>
nnoremap <leader>af :ALEFix<CR>
nnoremap <leader>ah :ALEHover<CR>

" ================= GO: iabbrev =================
iabbrev pkgm package main<CR><CR>func main() {<CR><CR>}<Up><Tab>
iabbrev impt import ""<Left>
iabbrev pfmt fmt.Println("")<Left><Left>
iabbrev errf if err != nil {<CR>log.Fatal(err)<CR>}<Up><Tab>

" ================= ПРОВЕРКА ЗАГРУЗКИ ПЛАГИНОВ =================
function! CheckPlugins()
    if !exists('g:loaded_ale')
        echo "ALE не загружен!"
    else
        echo "ALE загружен"
    endif
    if !exists('g:loaded_nerd_tree')
        echo "NERDTree не загружен!"
    else
        echo "NERDTree загружен"
    endif
endfunction
command! CheckPlugins call CheckPlugins()

