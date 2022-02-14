" ===
" === Auto load for first time uses
" ===
if empty(glob($HOME.'/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ===
" === System
" ===
set nocompatible
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
set mouse=a
set encoding=utf-8

" set clipboard=unnamed
" Prevent incorrect background rendering
let &t_ut=''
set autochdir

" ===
" === Main code display
" ===
set number
set relativenumber
set ruler
set cursorline
syntax enable
syntax on

" ===
" === Editor behavior
" ===

" Better tab
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set list
set listchars=tab:▸\ ,trail:▫
set scrolloff=5


" Better backspace
set backspace=indent,eol,start

set foldmethod=indent
set foldlevel=99

let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" ===
" === Status/command bar
" ===
set laststatus=2
set noshowmode
set showcmd
" set formatoptions-=tc

" Show command autocomplete
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu
" show a navigable menu for tab completion
set wildmode=longest,list,full

" Searching options
set hlsearch
exec "nohlsearch"
set incsearch
set ignorecase
set smartcase

" ===
" === Restore Cursor Position
" ===
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" ===
" === Basic Mappings
" ===

" Set <LEADER> as <SPACE>
let mapleader=" "

" Save & quit
map Q :q<CR>
map S :w<CR>

" Open the vimrc file anytime
map <LEADER>rc :e ~/.vim/vimrc<CR>

" Undo operations
noremap l u
" Undo in Insert mode
inoremap <C-l> <C-u>

" Insert Key
noremap k i
noremap K I

" Copy to system clipboard
vnoremap Y "+y

" ===
" === Cursor Movement
" ===
"
" New cursor movement (the default arrow keys are used for resizing windows)
"     ^
"     u
" < n   i >
"     e
"     v
noremap u k
noremap n h
noremap e j
noremap i l

" U/E keys for 10 times u/e (faster navigation)
noremap U 10k
noremap E 10j

" Faster in-line navigation
" noremap W 5w
" noremap B 5b

" N key: go to the start of the line
noremap N 0
" I key: go to the end of the line
noremap I $

" set h as n for search next, same as H as N
noremap h nzz
noremap H Nzz
noremap <LEADER><CR> :nohlsearch<CR>

" set j as e for jump to end of word
noremap j e

" ===
" === Window management
" ===
" Use <space> + new arrow keys for moving the cursor around windows
map <LEADER>w <C-w>w
map <LEADER>u <C-w>k
map <LEADER>e <C-w>j
map <LEADER>n <C-w>h
map <LEADER>i <C-w>l

" Disabling the default s key
noremap s <nop>

" split the screens to up (horizontal), down (horizontal), left (vertical), right (vertical)
map su :set nosplitbelow<CR>:split<CR>:set splitbelow<CR>
map se :set splitbelow<CR>:split<CR>
map sn :set nosplitright<CR>:vsplit<CR>:set splitright<CR>
map si :set splitright<CR>:vsplit<CR>

" Resize splits with arrow keys
map <up> :res +5<CR>
map <down> :res -5<CR>
map <left> :vertical resize-5<CR>
map <right> :vertical resize+5<CR>

" ===
" === Tab management
" ===
" change curruent window to new tab
map te <C-w>T
" Create a new tab with tu
map tu :tabe<CR>
" Move around tabs with tn and ti
map tn :-tabnext<CR>
map ti :+tabnext<CR>
" Move the tabs with tmn and tmi
map tmn :-tabmove<CR>
map tmi :+tabmove<CR>


" install plugins by vim-plug
call plug#begin()

Plug 'EdenEast/nightfox.nvim'
Plug 'itchyny/lightline.vim'
Plug 'mg979/vim-xtabline'
Plug 'liuchengxu/vista.vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'github/copilot.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'tpope/vim-surround'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

" theme configuration
if !has('gui_running')
  set t_Co=256
endif
colorscheme nightfox

" xtabline

" lightline and vista
noremap <LEADER>v :Vista!!<CR>
noremap <c-t> :silent! Vista finder coc<CR>
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'coc'
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction
set statusline+=%{NearestMethodOrFunction()}
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'method' ] ]
      \ },
      \ 'component_function': {
      \   'method': 'NearestMethodOrFunction'
      \ },
      \ }

" plugin configuration

" coc.nvim
" TextEdit might fail if hidden is not set.
set hidden
set updatetime=100
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
" coc plugins
let g:coc_global_extensions = [
      \ 'coc-clangd',
      \ 'coc-css',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-lists',
      \ 'coc-tsserver',
      \ 'coc-vetur',
      \ 'coc-explorer',
      \ 'coc-yank']

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" coc-yank
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>
" coc-explorer
" you need install nerd fonts for show the icon
nmap tt <Cmd>CocCommand explorer<CR>

" vim autoformat
let g:python3_host_prog="/Users/eyebrow/.pyenv/shims/python3"
map sf :Autoformat<CR>

" vim-surround
" type yskw' to wrap the word with '' or type cs'` to change 'word' to `word` S for visual mode

" nvim-treesitter
lua require('plugin-config/nvim-treesitter')
