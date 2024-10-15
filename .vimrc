" Gotta be first
set nocompatible

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'morhetz/gruvbox'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" ---- Vim as a programmer's text editor -----------------
"Plugin 'scrooloose/nerdtree'
"Plugin 'jistr/vim-nerdtree-tabs'
"Plugin 'vim-syntastic/syntastic'
Plugin 'dense-analysis/ale'
Plugin 'neoclide/coc.nvim'
Plugin 'xolox/vim-misc'
"Plugin 'xolox/vim-easytags'
"Plugin 'majutsushi/tagbar'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-scripts/a.vim'
Plugin 'tpope/vim-sleuth'

" ---- C# Plugins --------------------------------------
Plugin 'OmniSharp/omnisharp-vim'
" Mappings, code-actions available flag and statusline integration
Plugin 'nickspoons/vim-sharpenup'
" Vim FZF integration, used as OmniSharp selector
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" ---- Working with Git -------------------------
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
"Plugin 'Xuyuanp/nerdtree-git-plugin'

" ---- Other text editing features ------------------------
Plugin 'Raimondi/delimitMate'
Plugin 'preservim/vim-pencil'
Plugin 'godlygeek/tabular'
Plugin 'preservim/vim-markdown'
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'

" ---- man pages, tmux, system clipboard  -----------------
Plugin 'jez/vim-superman'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'jasonccox/vim-wayland-clipboard'

" ---- Extras/Advanced plugins ---------------------------
" Highlight and strip trailing whitespace
Plugin 'ntpeters/vim-better-whitespace'
" Easily surround chunks of text
Plugin 'tpope/vim-surround'
" Change quotes across lines
Plugin 'kana/vim-textobj-user'
Plugin 'beloglazov/vim-textobj-quotes'
" Automatically insert the closing HTML tag
Plugin 'HTML-AutoCloseTag'
" Markdown Preview in Browser
"Plugin 'iamcco/markdown-preview.nvim'
Plugin 'MeanderingProgrammer/render-markdown.nvim'
Plugin 'bullets-vim/bullets.vim'
" Decouple CursorHold events from update time
Plugin 'antoinemadec/FixCursorHold.nvim'

call vundle#end()

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

syntax on

set mouse=a

" ---- Keep cursor at center of screen ----
set scrolloff=999
"augroup VCenterCursor
"  au!
"  au BufEnter,WinEnter,WinNew,VimResized *,*.*
"        \ let &scrolloff=winheight(win_getid())/2
"augroup END


" We need this for plugins like Syntastic and vim-gitgutter which put symbols
" in the sign column
hi clear SignColumn
set signcolumn=number

" allow Ctrl-[ without timeout
set ttimeoutlen=0

" indentation jumping, sometimes useful
noremap <silent> <M-k> :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>
noremap <silent> <M-j> :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>

" ---- Indentation Settings ---------------------------
set autoindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
" Rebind shift-tab
" for command mode
nnoremap <S-Tab> <<
" for insert mode
inoremap <S-Tab> <C-d>

" ---- antoinemadec/FixCursorHold.nvim settings ----
" Time between CursorHolds, used for omnisharp
let g:cursorhold_updatetime=100

" ---- Indent on save ----
" Restore cursor position, window position, and last search after running a
" command.
function! Preserve(command)
  " Save the last search.
  let search = @/

  " Save the current cursor position.
  let cursor_position = getpos('.')

  " Save the current window position.
  normal! H
  let window_position = getpos('.')
  call setpos('.', cursor_position)

  " Execute the command.
  execute a:command

  " Restore the last search.
  let @/ = search

  " Restore the previous window position.
  call setpos('.', window_position)
  normal! zt

  " Restore the previous cursor position.
  call setpos('.', cursor_position)
endfunction

" Re-indent the whole buffer.
function! Indent()
  "normal mzgg=G`z
  call Preserve('normal gg=G')
endfunction

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

" ---- Theming ----
"  Toggle this to "light" for light colorscheme
set background=dark

" italics (must be before colorscheme)
let g:gruvbox_italic=1

" Set the colorscheme
colorscheme gruvbox

" ---- Plaintext editing settings ----
hi clear SpellBad
hi SpellBad cterm=underline
" Style for gvim
hi SpellBad gui=undercurl

" Set the filetype based on the file's extension, but only if
" 'filetype' has not already been set
au BufRead,BufNewFile *.cake setfiletype cs

" ---- Plugin-Specific Settings -------------------------
"
" ---- altercation/vim-colors-solarized settings -----

" Uncomment the next line if your terminal is not configured for solarized
" let g:solarized_termcolors=256

" Set the colorscheme
"colorscheme solarized

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

" Swap between light and dark backgrounds
function ToggleBackground()
    if &background == "dark"
        set background=light
    else
        set background=dark
    endif
endfunction

nmap <silent> <C-F6> :call ToggleBackground()<CR>

"autocmd vimenter * ++nested colorscheme gruvbox


" ---- bling/vim-airline settings ----
"  Always show statusbar
set laststatus=2

" Fancy arrow symbols, requires a patched font
" To install a patched font, run over to
"     https://github.com/abertsch/Menlo-for-Powerline
" download all the .ttf files, double-click on them and click "Install"
" Finally, uncomment the next line
let g:airline_powerline_fonts = 1

" Show PASTE if in paste mode
let g:airline_detect_paste=1

" Show airline for tabs too
let g:airline#extensions#tabline#enabled = 1

" Use the solarized theme for the Airline status bar
let g:airline_theme='gruvbox'

" ---- jistr/vim-nerdtree-tabs ----
"  Open/close NERDTree Tabs with \t
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
let g:nerdtree_tabs_open_on_console_startup = 0

" Show lines next to file
let g:NERDTreeFileLines = 1

" Show hidden files by default
let NERDTreeShowHidden=1

" ---- scrooloose/syntastic settings ----
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"
let g:syntastic_auto_jump = 2
augroup mySyntastic
  au!
  au FileType tex let b:syntastic_mode = "passive"
augroup END

" ---- dense-analysis/ale settings ----
let g:ale_sign_error = '✘'
let g:ale_sign_warning = "▲"
let g:ale_virtualtext_cursor = 'current'
let g:ale_linters = {
\   'c': ['gcc'],
\   'cs': ['OmniSharp']
\}
let g:ale_disable_lsp = 1

" disable echoing errors
let g:ale_echo_cursor = 0

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" ---- neoclide/coc.nvim settings ----
" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" disable on certain files
let s:coc_filetypes_disable = [ 'text', 'textile', 'markdown' ]
function! s:disable_coc_for_type()
  if index(s:coc_filetypes_disable, &filetype) != -1
    :silent! CocDisable
  endif
endfunction

augroup CocGroup
 autocmd!
 autocmd BufNew,BufEnter,BufAdd,BufCreate * call s:disable_coc_for_type()
augroup end

" ---- xolox/vim-easytags settings ----
" Where to look for tags files
set tags=./tags;,~/.vimtags
" Sensible defaults
let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_async = 1
let g:easytags_dynamic_files = 2
let g:easytags_resolve_links = 1
let g:easytags_suppress_ctags_warning = 1

" Update tags with Ctrl+[
"nmap <silent> <C-[> :UpdateTags<CR>

" ---- majutsushi/tagbar settings ----
" Open/close tagbar with \b
nmap <silent> <leader>b :TagbarToggle<CR>
" Uncomment to open tagbar automatically whenever possible.
"autocmd BufEnter * nested :call tagbar#autoopen(0)

" ---- OmniSharp/omnisharp-vim settings ----
" Set this to 1 to use ultisnips for snippet handling
let s:using_snippets = 0

let g:OmniSharp_server_path = '/home/cjohnson/.nix-profile/bin/OmniSharp'
" let g:OmniSharp_server_path = '/home/cjohnson/development/c#/omnisharp/run'


" Update highlighting after all text changes
let g:OmniSharp_highlighting = 3

let g:OmniSharp_popup_position = 'peek'
"if has('nvim')
  "let g:OmniSharp_popup_options = {
  ""\ 'winblend': 30,
  ""\ 'winhl': 'Normal:Normal,FloatBorder:ModeMsg',
  ""\ 'border': 'rounded'
  ""\}
"else
  "let g:OmniSharp_popup_options = {
  ""\ 'highlight': 'Normal',
  ""\ 'padding': [0],
  ""\ 'border': [1],
  ""\ 'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
  ""\ 'borderhighlight': ['ModeMsg']
  ""\}
"endif
"let g:OmniSharp_popup_mappings = {
""\ 'sigNext': '<C-n>',
""\ 'sigPrev': '<C-p>',
""\ 'pageDown': ['<C-f>', '<PageDown>'],
""\ 'pageUp': ['<C-b>', '<PageUp>']
""\}
"
"if s:using_snippets
  "let g:OmniSharp_want_snippet = 1
"endif
"
"let g:OmniSharp_highlight_groups = {
""\ 'ExcludedCode': 'NonText'
""\}

" OmniSharp commands
augroup omnisharp_commands
  autocmd!

  " Show type information automatically when the cursor stops moving.
  " Note that the type is echoed to the Vim command line, and will overwrite
  " any other messages in this space including e.g. ALE linting messages.
  autocmd CursorHold *.cs OmniSharpTypeLookup

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ost <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osd <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfx <Plug>(omnisharp_fix_usings)
  autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
  autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

  " Navigate up and down by method/property/field
  autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
  autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
  " Find all code errors/warnings for the current solution and populate the quickfix window
  autocmd FileType cs nmap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)
  " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  " Repeat the last code action performed (does not use a selector)
  autocmd FileType cs nmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)
  autocmd FileType cs xmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)

  autocmd FileType cs nmap <silent> <buffer> <Leader>os= <Plug>(omnisharp_code_format)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osnm <Plug>(omnisharp_rename)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osre <Plug>(omnisharp_restart_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osst <Plug>(omnisharp_start_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ossp <Plug>(omnisharp_stop_server)
augroup END

" ---- nickspoons/vim-sharpenup settings ----
" All sharpenup mappings will begin with `<Space>os`, e.g. `<Space>osgd` for
" :OmniSharpGotoDefinition
let g:sharpenup_map_prefix = '<Space>os'

" ---- airblade/vim-gitgutter settings ----
" In vim-airline only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#ale#enabled = 1

" Makes signpost same color as line numbers
highlight clear SignColumn

" ---- Xuyuanp/nerdtree-git-plugin settings ----
" Enable nerd font icons
" let g:NERDTreeGitStatusUseNerdFonts = 1

" Show clean indicator
let g:NERDTreeGitStatusShowClean = 1

" Hide brackets (don't enable if devicons are installed)
let g:NERDTreeGitStatusConcealBrackets = 1

" ---- Raimondi/delimitMate settings ----
let delimitMate_expand_cr = 1
augroup mydelimitMate
  au!
  au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
  au FileType tex let b:delimitMate_quotes = ""
  au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
  au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END

" ---- vim-scripts/vim-pencil settings ----
let g:pencil#wrapModeDefault = 'soft'
augroup pencil
  autocmd!
  autocmd FileType markdown call pencil#init()
  autocmd FileType textile call pencil#init()
  autocmd FileType text call pencil#init({'wrap': 'hard'})
augroup END

" ---- junegunn/goyo.vim settings ----
" cannot figure this out
"augroup goyo_enable
"  autocmd!
"  autocmd FileType markdown Goyo
"  autocmd FileType textile Goyo
"  autocmd FileType text Goyo
"augroup END

" ---- junegunn/limelight.vim settings ----
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" ---- jez/vim-superman settings ----
" better man page support
noremap K :SuperMan <cword><CR>

" ---- jasonccox/vim-wayland-clipboard settings ----
set clipboard=unnamedplus
