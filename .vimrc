"
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|
"
"======================================================================
" Plugins: Vim-plug Plugin Manager
"======================================================================

call plug#begin('~/.vim/plugged')

Plug 'turbio/bracey.vim'

call plug#end()


"======================================================================
" Basic Configuration:
"======================================================================
" Resources:
" https://www.youtube.com/watch?v=XA2WjJbmmoM
" https://github.com/nickjj/dotfiles/blob/master/.vimrc
" https://github.com/srydell/dotfiles/blob/master/vim/.vim/vimrc

filetype plugin indent on
syntax enable

set viminfo='100,n$HOME/.vim/files/info/viminfo'

" Navigation
set number
"set relativenumber
set hlsearch incsearch
set mouse=a

" Wildmenu
set wildmenu
set wildmode=longest,list,full
set wildoptions=tagfile
set wildignorecase
set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out,*~,%*
set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
set wildignore+=application/vendor/**,**/vendor/ckeditor/**,media/vendor/**
set wildignore+=__pycache__,*.egg-info,.pytest_cache

" Timing
set timeout ttimeout
set timeoutlen=500  " Time out on mappings
set ttimeoutlen=10  " Time out on key codes

if has('folding')
	set foldenable
	set foldmethod=syntax
	set foldlevelstart=99
endif

" Tabsize
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab smarttab

" enable system clipboard
set clipboard+=unnamedplus

" Panes and Windows
set splitright
set splitbelow

" Indentation
set smartindent
set autoindent

" Text Editing
set spelllang=en_us
set smartcase
set ignorecase
set nospell
set wrap
set whichwrap=b,s,<,>
set textwidth=0
set encoding=utf-8
set ruler
set backspace=indent,eol,start
set completeopt=noselect,longest,menuone,preview
set scrolloff=5
set virtualedit=block
set matchpairs+=<:>          " Use % to jump between pairs
set updatetime=300           " For faster diagnostics

" Others
set hidden
set ttimeout
set showmatch
set laststatus=2
set showcmd		     " Disable when vim slows down
set magic                    " For regular expressions turn magic on
set path=.,**                " Directories to search when using gf
set colorcolumn=80

" Enables 24-bit RGB color in the TUI
if has('termguicolors')
	set termguicolors
endif

" Creating backup files when editing in case vim crashes
" Resources:
" https://medium.com/@Aenon/vim-swap-backup-undo-git-2bf353caa02f
" https://github.com/srydell/dotfiles/blob/master/vim/.vim/vimrc
set backupdir=~/.vim/tmp/backup//
set directory=~/.vim/tmp/swap//
set undodir=~/.vim/tmp/undo//

" Nvim specific settings
if !has('nvim')
  set ttymouse=sgr
  set cryptmethod=blowfish2
  set ttyfast
endif

runtime! macros/matchit.vim " enabled awesome match abilities like HTML tag matching with %


"======================================================================
" Basic Mappings:
"======================================================================

let mapleader = '\'      " See :help expr-string for syntax docs
let maplocalleader = '\'

" Remap f1 to fzf helptags instead of default help
map <f1> :Helptags<CR>

" buffer navigation
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [B :bfirst<CR>
nnoremap ]B :blast<CR>

" delete buffer
nnoremap <C-x> :bd<CR>

"tabline navigation
noremap [t :tabprevious<cr>
noremap ]t :tabnext<cr>
noremap [T :tabfirst<cr>
noremap ]T :tablast<cr>
noremap <leader>tn :tabnew<cr>
noremap <leader>tc :tabclose<cr>
noremap <leader>te :tabedit
noremap <leader>tm :tabmove

" Open current file with wsl-open
nnoremap <leader>xo :!wsl-open %<cr>

" Move through the valid compilers. Set by b:valid_compilers
"nnoremap <silent> [c :CompilerPrevious<CR>
"nnoremap <silent> ]c :CompilerNext<CR>

" Move through the loclist
nnoremap <silent> <leader>l :call utils#ToggleList("Location List", 'l')<CR>
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [L :lfirst<CR>
nnoremap <silent> ]L :llast<CR>

" Move through the quickfix list
nnoremap <silent> <leader>q :call utils#ToggleList("Quickfix List", 'c')<CR>
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]Q :clast<CR>

" Keep selection while indenting
vnoremap <silent> > ><cr>gv
vnoremap <silent> < <<cr>gv

" Write all buffers and exit
" If there are buffers without a name,
" or that are readonly, bring up a confirm prompt
nnoremap <leader>W :confirm wqall<CR>
" quit all without saving
nnoremap <leader>Q :confirm qall<CR>

" Write buffer (save)
noremap <Leader>w :w<CR>
imap <C-S> <esc>:w<CR>
imap <C-Q> <esc>:wq<CR>

" Seamlessly treat visual lines as actual lines when moving around.
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap gj j
nnoremap gk k

" Make Y more consistent with C and D
nnoremap Y y$

" Remove spaces at the end of lines
nnoremap <silent> ,<Space> :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>

" Keep cursor at the bottom of the visual selection after you yank it.
vmap y ygv<Esc>

" Navigate around splits in any mode `ALT+{h,j,k,l}
"tnoremap <A-h> <C-\><C-N><C-w>h
"tnoremap <A-j> <C-\><C-N><C-w>j
"tnoremap <A-k> <C-\><C-N><C-w>k
"tnoremap <A-l> <C-\><C-N><C-w>l
"inoremap <A-h> <C-\><C-N><C-w>h
"inoremap <A-j> <C-\><C-N><C-w>j
"inoremap <A-k> <C-\><C-N><C-w>k
"inoremap <A-l> <C-\><C-N><C-w>l
"nnoremap <A-h> <C-w>h
"nnoremap <A-j> <C-w>j
"nnoremap <A-k> <C-w>k
"nnoremap <A-l> <C-w>l

" Simulate i_CTRL-R in terminal-mode:
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

" Allow <Esc> to exit terminal-mode back to normal:
tnoremap <Esc> <C-\><C-n>

" Cycle through splits.
nnoremap <S-Tab> <C-w>w

" Press * to search for the term under the cursor or a visual selection and
" then press a key below to replace all instances of it in the current file.
nnoremap <Leader>r :%s///g<Left><Left>
nnoremap <Leader>rc :%s///gc<Left><Left><Left>

" The same as above but instead of acting on the whole file it will be
" restricted to the previously visually selected range. You can do that by
" pressing *, visually selecting the range you want it to apply to and then
" press a key below to replace all instances of it in the current selection.
xnoremap <Leader>r :s///g<Left><Left>
xnoremap <Leader>rc :s///gc<Left><Left><Left>

" Prevent x from overriding what's in the clipboard.
noremap x "_x
noremap X "_x

" Format paragraph (selected or not) to 80 character lines.
nnoremap <Leader>g gqap
xnoremap <Leader>g gqa

" Prevent selecting and pasting from overwriting what you originally copied.
xnoremap p pgvy

" Edit Vim config file in a new tab.
map <Leader>ev :tabnew $MYVIMRC<CR>

" Source Vim config file.
map <Leader>sv :source $MYVIMRC<CR>

" Clear search highlights.
map <Leader><Space> :let @/=''<CR>

" Toggle spell check.
map <leader><F3> :setlocal spell!<CR>

" Toggle quickfix window.
function! QuickFix_toggle()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
            cclose
            return
        endif
    endfor

    copen
endfunction
nnoremap <silent> <Leader>q :call QuickFix_toggle()<CR>

" Improve scroll, credits: https://github.com/Shougo
nnoremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
	\ 'zt' : (winline() == 1) ? 'zb' : 'zz'
noremap <expr> <C-f> max([winheight(0) - 2, 1])
	\ ."\<C-d>".(line('w$') >= line('$') ? "L" : "M")
noremap <expr> <C-b> max([winheight(0) - 2, 1])
	\ ."\<C-u>".(line('w0') <= 1 ? "H" : "M")
noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "3\<C-e>")
noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "3\<C-y>")

" open current file with system default
nnoremap <leader>p :!chrome.exe %<CR>

" command line alias
"cnoremap w!! w !sudo tee % >/dev/null
cnoremap <C-p> <Up>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-h> <BS>
cnoremap <C-t> <C-R>=expand("%:p:h") . "/" <CR>

" insert keymap like emacs
inoremap <C-w> <C-[>diwa
inoremap <C-h> <BS>
inoremap <C-d> <Del>
inoremap <C-k> <ESC>d$a
inoremap <C-u> <C-G>u<C-U>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <Home>

" settings for resize splitted window
nmap <C-w>[ :vertical resize -3<CR>
nmap <C-w>] :vertical resize +3<CR>


"======================================================================
" Autocommands:
"======================================================================

" Reduce delay when switching between modes.
augroup NoInsertKeycodes
  autocmd!
  autocmd InsertEnter * set ttimeoutlen=0
  autocmd InsertLeave * set ttimeoutlen=10
augroup END

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Auto-resize splits when Vim gets resized.
autocmd VimResized * wincmd =

" Update a buffer's contents on focus if it changed outside of Vim.
au FocusGained,BufEnter * :checktime







"**********************************************************************
" Scrap codes for reference purposes
"**********************************************************************

"" Airline theme plugin for tabline bar and status bar
"Plugin 'vim-airline/vim-airline'
"Plugin 'vim-airline/vim-airline-themes'
"
"" Airline Configurations:
"let g:airline#extensions#tabline#enabled = 1       " Enables tabline theme
"let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
"let g:airline_theme='base16_gruvbox_dark_hard'
"
"let g:airline_powerline_fonts = 1
"
"if !exists('g:airline_symbols')
"    let g:airline_symbols = {}
"  endif
"
"  " unicode symbols
"  let g:airline_left_sep = '»'
"  let g:airline_left_sep = '▶'
"  let g:airline_right_sep = '«'
"  let g:airline_right_sep = '◀'
"  let g:airline_symbols.crypt = '🔒'
"  let g:airline_symbols.linenr = '☰'
"  let g:airline_symbols.linenr = '␊'
"  let g:airline_symbols.linenr = '␤'
"  let g:airline_symbols.linenr = '¶'
"  let g:airline_symbols.maxlinenr = ''
"  let g:airline_symbols.maxlinenr = '㏑'
"  let g:airline_symbols.branch = '⎇'
"  let g:airline_symbols.paste = 'ρ'
"  let g:airline_symbols.paste = 'Þ'
"  let g:airline_symbols.paste = '∥'
"  let g:airline_symbols.spell = 'Ꞩ'
"  let g:airline_symbols.notexists = 'Ɇ'
"  let g:airline_symbols.whitespace = 'Ξ'
"
"  " powerline symbols
"  let g:airline_left_sep = ''
"  let g:airline_left_alt_sep = ''
"  let g:airline_right_sep = ''
"  let g:airline_right_alt_sep = ''
"  let g:airline_symbols.branch = ''
"  let g:airline_symbols.readonly = ''
"  let g:airline_symbols.linenr = '☰'
"  let g:airline_symbols.maxlinenr = ''
"  let g:airline_symbols.dirty= '⚡'

"======================================================================

"" Html, CSS, JavaScript Live Server
"" Dependencies are required to be installed along with the plugin
"" Ref: https://github.com/turbio/bracey.vim#installation
"Plugin 'turbio/bracey.vim'
"
" Bracey Configurations:
"let g:bracey_refresh_on_save = 1
"let g:bracey_server_port = 8080

"======================================================================

"" Automatically set 'shiftwidth' + 'expandtab' (indention) based on file type.
"Plug 'tpope/vim-sleuth'

"======================================================================

"""If 'ycmd server SHUT DOWN' issue arise:
"""  https://stackoverflow.com/a/49070576/11850077
"Plug 'Valloric/YouCompleteMe'
"
"" Removes key binding with <Tab> from ycm to fix issues not autocompleteing
"" when selecting a suggestion let g:ycm_key_list_select_completion = [] let
" g:ycm_key_list_previous_completion = []

"======================================================================

"" Run test suites for various languages.
"Plug 'janko/vim-test'


"" Add spelling errors to the quickfix list (vim-ingo-library is a dependency).
"Plug 'inkarkat/vim-ingo-library' | Plug 'inkarkat/vim-SpellCheck'


""======================================================================
"" Gruvbox theme.
""======================================================================
"
"" Ref:
""   https://github.com/nickjj/dotfiles/blob/master/.vimrc
""
"Plug 'gruvbox-community/gruvbox'
"
""--------------------------------------------------
"" Color settings
""--------------------------------------------------
"
""                                        *** On ***
"
"colorscheme gruvbox
"" For Gruvbox to look correct in terminal Vim you'll want to source a palette
"" script that comes with the Gruvbox plugin.
"
"" Add this to your ~/.profile file:
""   source "$HOME/.vim/plugged/gruvbox/gruvbox_256palette.sh"
"
"" Gruvbox comes with both a dark and light theme.
"set background=dark
"
"" Gruvbox has 'hard', 'medium' (default) and 'soft' contrast options.
"let g:gruvbox_contrast_light='soft'
"
"" This needs to come last, otherwise the colors aren't correct.
"syntax on
"
""--------------------------------------------------
"" Status line
""--------------------------------------------------
"
"                                        *** Off ***
"
"" Heavily inspired by: https://github.com/junegunn/dotfiles/blob/master/vimrc
"function! s:statusline_expr()
"  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
"  let ro  = "%{&readonly ? '[RO] ' : ''}"
"  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
"  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
"  let sep = ' %= '
"  let pos = ' %-12(%l : %c%V%) '
"  let pct = ' %P'
"
"  return '[%n] %f %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
"endfunction
"
"let &statusline = s:statusline_expr()
"
""--------------------------------------------------
"" Change status line color for insert and replace modes
""--------------------------------------------------
"
"                                        *** Off ***
"
"" Optimized for gruvbox:hard (both dark and light).
"function! InsertStatuslineColor(mode)
"  if a:mode == 'i'
"    if (&background == 'dark')
"      hi StatusLine ctermfg=109 ctermbg=0 guifg=#83a598 guibg=#000000
"    else
"      hi StatusLine ctermfg=24 ctermbg=255 guifg=#076678 guibg=#ffffff
"    endif
"  elseif a:mode == 'r'
"    if (&background == 'dark')
"      hi StatusLine ctermfg=106 ctermbg=0 guifg=#98971a guibg=#000000
"    else
"      hi StatusLine ctermfg=100 ctermbg=255 guifg=#79740e guibg=#ffffff
"    endif
"  else
"    if (&background == 'dark')
"      hi StatusLine ctermfg=166 ctermbg=0 guifg=#d65d0e guibg=#000000
"    else
"      hi StatusLine ctermfg=88 ctermbg=255 guifg=#9d0006 guibg=#ffffff
"    endif
"  endif
"endfunction
"
"function! InsertLeaveActions()
"  if (&background == 'dark')
"    au InsertLeave * hi StatusLine ctermfg=239 ctermbg=223 guifg=#504945 guibg=#ebdbb2
"  else
"    au InsertLeave * hi StatusLine ctermfg=250 ctermbg=0 guifg=#d5c4a1 guibg=#000000
"  endif
"endfunction
"
"au InsertEnter * call InsertStatuslineColor(v:insertmode)
"au InsertChange * call InsertStatuslineColor(v:insertmode)
"au InsertLeave * call InsertLeaveActions()
"
"" Ensure status line color gets reverted if exiting insert mode with CTRL + C.
"inoremap <C-c> <C-o>:call InsertLeaveActions()<CR><C-c>

"======================================================================

"" Deoplete Autocompletion
"  if has('nvim')
"    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"  else
"    Plug 'Shougo/deoplete.nvim'
"    Plug 'roxma/nvim-yarp'
"    Plug 'roxma/vim-hug-neovim-rpc'
"  endif
"  " Configurations
"    let g:deoplete#enable_at_startup = 1
"    " <TAB>: completion.
"    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"    let g:python_host_prog = '/usr/bin/python2.7'
"    let g:python3_host_prog = '/usr/bin/python3.6'
"
"" Deoplete Sources
"Plug 'deoplete-plugins/deoplete-jedi'
"Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
"Plug 'Shougo/neosnippet'
"Plug 'Shougo/neosnippet-snippets'
"  let g:neosnippet#enable_completed_snippet = 1
"
"Plug 'wokalski/autocomplete-flow'

"======================================================================

"Plug 'vim-syntastic/syntastic'
""Syntastic Configurations:
"  set statusline+=%#warningmsg#
"  set statusline+=%{SyntasticStatuslineFlag()}
"  set statusline+=%*
"
"  let g:syntastic_always_populate_loc_list = 1
"  let g:syntastic_auto_loc_list = 1
"  let g:syntastic_check_on_open = 1
"  let g:syntastic_check_on_wq = 0

"======================================================================

" " Ncm2 Autocompletion
"   " assuming you're using vim-plug: https://github.com/junegunn/vim-plug
"   Plug 'ncm2/ncm2'
"   Plug 'roxma/nvim-yarp'

"   " enable ncm2 for all buffers
"   autocmd BufEnter * call ncm2#enable_for_buffer()

"   " IMPORTANT: :help Ncm2PopupOpen for more information
"   set completeopt=noinsert,menuone,noselect

"   " NOTE: you need to install completion sources to get completions. Check
"   " our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
"   Plug 'ncm2/ncm2-bufword'
"   Plug 'ncm2/ncm2-path'

"   " Ncm2 Configuration:
"     " When the <Enter> key is pressed while the popup menu is visible, it only
"     " hides the menu. Use this mapping to close the menu and also start a new
"     " line.
"     "inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

"     " Use <TAB> to select the popup menu:
"     inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"     inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" " Ncm2 language sources
" Plug 'ncm2/ncm2-tern',  {'do': 'npm install'}
" Plug 'ncm2/ncm2-cssomni'
" Plug 'ncm2/ncm2-html-subscope'
" Plug 'ncm2/ncm2-jedi'
" " Ncm2-jedi Configuration:
"   let g:python_host_prog = '/usr/bin/python2.7'
"   let g:python3_host_prog = '/usr/bin/python3.6'
" Plug 'ncm2/ncm2-ultisnips'
" " Ncm2-ultisnips Configuration:
"   " Press enter key to trigger snippet expansion
"   " The parameters are the same as `:help feedkeys()`
"   inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

" " C-j C-k for moving in snippet
"   " let g:UltiSnipsExpandTrigger		= "<Plug>(ultisnips_expand)"
"   let g:UltiSnipsJumpForwardTrigger	= "<C-j>"
"   let g:UltiSnipsJumpBackwardTrigger	= "<C-k>"
"   let g:UltiSnipsRemoveSelectModeMappings = 0

" " Ncm2 Utils
" Plug 'ncm2/ncm2-match-highlight'

"set completeopt=longest,menuone,preview     # Removed for ncm2

"======================================================================

" A bunch of useful language related snippets (ultisnips is the engine).
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

"Plug 'prettier/vim-prettier', { 'do': 'npm install' }

"" Inserts multiple cursors just like sublime editor
"call dein#add 'terryma/vim-multiple-cursors'

