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
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'vim-syntastic/syntastic'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-scripts/a.vim'

" ---- Working with Git -------------------------
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'Xuyuanp/nerdtree-git-plugin'

" ---- Other text editing features ------------------------
Plugin 'Raimondi/delimitMate'

" ---- man pages, tmux, system clipboard  -----------------
Plugin 'jez/vim-superman'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'jasonccox/vim-wayland-clipboard'

" ---- Extras/Advanced plugins ---------------------------
" Highlight and strip trailing whitespace
Plugin 'ntpeters/vim-better-whitespace'
" Easily surround chunks of text
Plugin 'tpope/vim-surround'
" Automatically insert the closing HTML tag
Plugin 'HTML-AutoCloseTag'

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
  call Preserve('normal gg=G')
endfunction


" ---- Let's save undo info! ----
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile

" ---- Write to file with sudo ----
command WriteSudo w !sudo tee %

" ---- Plugin-Specific Settings -------------------------
"
" ---- altercation/vim-colors-solarized settings -----
"  Toggle this to "light" for light colorscheme
set background=dark

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

" italics (must be before colorscheme)
let g:gruvbox_italic=1

" Set the colorscheme
colorscheme gruvbox
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
augroup mySyntastic
  au!
  au FileType tex let b:syntastic_mode = "passive"
augroup END

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
nmap <silent> <C-[> :UpdateTags<CR>

" ---- majutsushi/tagbar settings ----
" Open/close tagbar with \b
nmap <silent> <leader>b :TagbarToggle<CR>
" Uncomment to open tagbar automatically whenever possible.
"autocmd BufEnter * nested :call tagbar#autoopen(0)

" ---- airblade/vim-gitgutter settings ----
" In vim-airline only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1

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

" ---- jez/vim-superman settings ----
" better man page support
noremap K :SuperMan <cword><CR>

" ---- jasonccox/vim-wayland-clipboard settings ----
set clipboard=unnamedplus
