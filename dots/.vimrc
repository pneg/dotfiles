" Gotta be first
set nocompatible

filetype off

" ---- Plugins -------------------------------------------
call plug#begin()
" ---- General Plugins -----------------------------------
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
"Plug 'lambdalisue/vim-fern'
Plug 'tpope/vim-vinegar'

" ---- Vim as a programmer's text editor -----------------
Plug 'girishji/vimcomplete'
Plug 'girishji/ngram-complete.vim'
Plug 'yegappan/lsp'
Plug 'girishji/scope.vim'
Plug 'girishji/devdocs.vim'
Plug 'tpope/vim-sleuth'
Plug 'puremourning/vimspector'

" ---- Git -------------------------
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" ---- Other text editing features ------------------------
"Plug 'Raimondi/delimitMate'
Plug 'justinmk/vim-sneak'

" ---- Plaintext -------------------------
Plug 'preservim/vim-pencil', { 'for': ['text', 'markdown', 'org'] }
Plug 'junegunn/goyo.vim', { 'for': ['text', 'markdown', 'org'] }
Plug 'junegunn/limelight.vim', { 'for': ['text', 'markdown', 'org'] }

" ---- tmux, system clipboard  -----------------
Plug 'christoomey/vim-tmux-navigator'
Plug 'jasonccox/vim-wayland-clipboard'

" ---- Extras/Advanced plugins ---------------------------
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/HTML-AutoCloseTag', { 'for': ['html', 'javascript'] }
"Plug 'antoinemadec/FixCursorHold.nvim'
"Plug 'takac/vim-hardtime'

call plug#end()

filetype plugin indent on

" ---- General settings --------------------------------
set backspace=indent,eol,start
set ruler
set relativenumber
set number
set showcmd
set incsearch
set hlsearch
set ignorecase
set smartcase
set wrap
set textwidth=80

syntax on

set mouse=a

" rebind leader
let mapleader = " "

set scrolloff=4

" We need this for plugins like lsp and vim-gitgutter which put symbols
" in the sign column
hi clear SignColumn
set signcolumn=yes
autocmd Filetype man setlocal signcolumn=no

" allow Ctrl-[ without timeout
set ttimeoutlen=0

" insert newline in normal mode without going into insert
nnoremap <Leader>o o<Esc>0"_D
nnoremap <Leader>O O<Esc>0"_D

" bind nohl
nnoremap <Leader>n :nohl<CR>

" Remember cursor position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
endif

" ---- Let's save undo info! ----
if !isdirectory($HOME."/.cache/vim")
    call mkdir($HOME."/.cache/vim", "", 0770)
endif
if !isdirectory($HOME."/.cache/vim/undo-dir")
    call mkdir($HOME."/.cache/vim/undo-dir", "", 0700)
endif
set undodir=~/.cache/vim/undo-dir
set undofile

" ---- Write to file with sudo ----
command WriteSudo w !sudo tee %

" Make Ctrl-Backspace work
imap <C-BS> <C-W>

" append/insert any text object
" https://gist.github.com/wellle/9289224
nnoremap <silent> <Leader>a :set opfunc=Append<CR>g@
nnoremap <silent> <Leader>i :set opfunc=Insert<CR>g@
function! Append(type, ...)
    call feedkeys("`]a", 'n')
endfunction

function! Insert(type, ...)
    call feedkeys("`[i", 'n')
endfunction

" Terminal problems
set t_SH=
set t_RS=

" Try and make things faster
set noswapfile
set lazyredraw

" ---- Indentation Settings ---------------------------
set autoindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
" Rebind shift-tab for insert mode
inoremap <S-Tab> <C-d>

" see tabs
set listchars=tab:▷▷⋮
set invlist

" ---- Programming settings ------------------------
" Disable comments automatically inserting on new line
autocmd FileType * set formatoptions-=cro

" folding settings
set foldmethod=manual
set foldnestmax=2
set foldopen-=block
au BufRead * normal zM
" save folds
" unfortunately this also preserves the foldmethod
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

" netrw nerdtree-like setup
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 10
nmap <Leader>t :Vexplore<CR>


" ---- Plaintext editing settings ----
hi clear SpellBad
hi SpellBad cterm=underline
" Style for gvim
hi SpellBad gui=undercurl

function! EnableSpellCheck()
  set spell spelllang=en_us
endfunction
function! DisableSpellCheck()
  set nospell
endfunction

" ---- Theming ----
set background=dark

" italics (must be before colorscheme)
let g:gruvbox_italic=1

" Set the colorscheme
colorscheme gruvbox

" ---- Plugin-Specific Settings -------------------------

" ---- morhetz/gruvbox settings ----
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal')
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" ---- itchyny/lightline.vim settings ----
"  Always show statusbar
set laststatus=2
" get rid of echoing mode
set noshowmode

let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" ---- girishji/vimcomplete settings ----
let g:vimcomplete_tab_enable = 1

let vimcompleteOptions = #{
      \  lsp: #{ priority: 20 }
      \}

autocmd VimEnter * call g:VimCompleteOptionsSet(vimcompleteOptions)
autocmd FileType markdown VimCompleteDisable

" ---- yegappan/lsp settings ----
let lspOpts = #{autoHighlightDiags: v:true}
autocmd User LspSetup call LspOptionsSet(lspOpts)

let lspServers = [#{
      \	  name: 'clang',
      \	  filetype: ['c', 'cpp'],
      \	  path: '/usr/bin/clangd',
      \	  args: ['--background-index']
      \ }, #{
      \	  name: 'jdtls',
      \	  filetype: 'java',
      \	  path: '/usr/bin/jdtls',
      \	  args: []
      \ }, #{
      \	  name: 'OmniSharp',
      \	  filetype: 'cs',
      \	  path:'/usr/bin/OmniSharp',
      \	  args: ['-z', '--languageserver', '--encoding', 'utf-8']
      \ }]
autocmd User LspSetup call LspAddServer(lspServers)

nmap <Leader>l :LspDiagShow<CR>

" ---- girishji/scope.vim settings ----
nnoremap <Leader>f :call g:scope#fuzzy#File()<cr>

" ---- girishji/devdocs.vim settings ----
nnoremap <Leader>d :DevdocsFind<CR>

" ---- puremourning/vimspector settings ----
let g:vimspector_enable_mappings = 'HUMAN'

" ---- airblade/vim-gitgutter settings ----
" In vim-airline only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#ale#enabled = 1

" Makes signpost same color as line numbers
highlight clear SignColumn

" ---- Raimondi/delimitMate settings ----
let delimitMate_expand_cr = 1
augroup mydelimitMate
  au!
  au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
  au FileType tex let b:delimitMate_quotes = ""
  au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
  au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END

" ---- justinmk/vim-sneak settings ----
let g:sneak#label = 1
map f <Plug>Sneak_s
map F <Plug>Sneak_S

" ---- vim-scripts/vim-pencil settings ----
let g:pencil#wrapModeDefault = 'hard'
augroup pencil
  autocmd!
  autocmd FileType markdown call pencil#init()
  "autocmd FileType textile call pencil#init()
  "autocmd FileType text call pencil#init({'wrap': 'hard'})
augroup END

" ---- junegunn/goyo.vim settings ----
autocmd! User GoyoEnter call EnableSpellCheck()
autocmd! User GoyoLeave call DisableSpellCheck()
"autocmd! User GoyoEnter Limelight | call EnableSpellCheck()
"autocmd! User GoyoLeave Limelight! | call DisableSpellCheck()

" ---- antoinemadec/FixCursorHold.nvim settings ----
" Time between CursorHolds
"let g:cursorhold_updatetime=100

" ---- takac/vim-hardtime settings ----
let g:hardtime_default_on = 1
