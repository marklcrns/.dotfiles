" Useful Default Mappings Vim Commands Reference
" https://bencrowder.net/files/vim-fu/
"======================================================================
" General Configurations and Mappings in ~/.vimrc
"======================================================================

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

"======================================================================
" Nvim Plugins: Dein Plugin Manager
"======================================================================
" Resources:
" Lazy Loading: https://herringtondarkholme.github.io/2016/02/26/dein/

"dein Scripts-----------------------------

if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
  set runtimepath+=/home/marklcrns/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/marklcrns/.cache/dein')
  call dein#begin('/home/marklcrns/.cache/dein')

" Let dein manage dein
" Required:
  call dein#add('/home/marklcrns/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Auto Completion (Completion sources in Coc Config section below)
  call dein#add('neoclide/coc.nvim', {'merge':0, 'rev': 'release'})
  call dein#add('honza/vim-snippets')

  " Language Plugins
  call dein#add('sheerun/vim-polyglot')
  call dein#add('iamcco/markdown-preview.nvim',
    \ {'on_ft': ['markdown', 'pandoc.markdown', 'rmd'],
    \ 'build': 'cd app & npm install' })
  call dein#add('othree/html5.vim')
  "call dein#add('turbio/bracey.vim')

  " Utilities
  call dein#add('dhruvasagar/vim-zoom')
  call dein#add('junegunn/goyo.vim',
    \ {'on_cmd': 'Goyo'})
  call dein#add('junegunn/limelight.vim',
    \ {'on_cmd': ['Limelight', 'Limelight!']})
  call dein#add('janko/vim-test',
    \ {'on_cmd': ['TestFile', 'TestNearest', 'TestSuit']})
  call dein#add('haya14busa/is.vim')  " Automate clearing search hightlight
  call dein#add('~/.fzf')
  call dein#add('junegunn/fzf.vim')
  call dein#add('airblade/vim-rooter')

  " File Managers
  call dein#add('scrooloose/nerdtree',
    \ {'on_cmd': ['NERDTree', 'NERDTreeClose', 'NERDTreeFind']})
  call dein#add('Xuyuanp/nerdtree-git-plugin')
  call dein#add('ryanoasis/vim-devicons')
  call dein#add('tiagofumo/vim-nerdtree-syntax-highlight')
  call dein#add('Shougo/defx.nvim')
  call dein#add('kristijanhusak/defx-git')
  call dein#add('kristijanhusak/defx-icons')
  call dein#add('Shougo/denite.nvim')
  call dein#add('neoclide/denite-git')
  call dein#add('neoclide/vim-easygit')

  " Syntax Helpers
  call dein#add('scrooloose/nerdcommenter')
  call dein#add('tpope/vim-surround')
  call dein#add('mattn/emmet-vim')
  call dein#add('ntpeters/vim-better-whitespace')
  call dein#add('tpope/vim-repeat')
  call dein#add('tpope/vim-sleuth')
  call dein#add('jiangmiao/auto-pairs')
  call dein#add('junegunn/vim-easy-align')
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('dhruvasagar/vim-table-mode')

  " Editor Navigation
  call dein#add('easymotion/vim-easymotion')
  call dein#add('rhysd/accelerated-jk')

  " Tags Manager
  call dein#add('ludovicchabant/vim-gutentags')
  call dein#add('majutsushi/tagbar')
  call dein#add('liuchengxu/vista.vim')

  " Tmux
  call dein#add('tmux-plugins/vim-tmux')
  call dein#add('christoomey/vim-tmux-navigator')
  call dein#add('tmux-plugins/vim-tmux-focus-events')
  call dein#add('benmills/vimux')

  " Git
  call dein#add('tpope/vim-fugitive')
  call dein#add('airblade/vim-gitgutter')

  " Themes
  call dein#add('gruvbox-community/gruvbox')
  call dein#add('itchyny/lightline.vim')
  call dein#add('bagrat/vim-buffet')

  " Extras
  call dein#add('wlemuel/vim-tldr')
  call dein#add('mhinz/vim-startify')
  call dein#add('yuttie/comfortable-motion.vim')
  call dein#add('thinca/vim-quickrun')
  call dein#add('simnalamburt/vim-mundo')
  "call dein#add('liuchengxu/vim-which-key',
    "\ { 'on_cmd': ['WhichKey', 'WhichKey!'] })

" Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------


"======================================================================
" Plugins Configurations:
"======================================================================

""--------------------------------------------------
"" CoC Config
""--------------------------------------------------
"" Resources:
"" https://www.narga.net/how-to-set-up-code-completion-for-vim/
"" https://www.youtube.com/watch?v=gnupOrSEikQ&t=266s
"" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
"" https://github.com/neoclide/coc.nvim/wiki

let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-snippets',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-emmet',
  \ 'coc-html',
  \ 'coc-tsserver',
  \ 'coc-stylelint',
  \ 'coc-css',
  \ 'coc-python',
  \ 'coc-markdownlint',
  \ 'coc-highlight',
  \ 'coc-lists',
  \ 'coc-yank',
  \ 'coc-git'
  \ ]


" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300  " Idle time to write swap and trigger CursorHold

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" use <tab> for trigger completion and navigate to the next complete item
inoremap <silent><expr> <Tab>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ?
      \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
let g:coc_snippet_prev = '<S-TAB>'

"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" `<C-g>u` means break undo chain at current position.
" Remap <CR> to just go to next line instead of auto completing
"inoremap <silent><expr> <cr> "\<C-e>\<CR>"
" Same as above
"inoremap <silent><expr> <cr> "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <Tab> for confirm completion.
" Coc only does snippet and additional edit on confirm.
"inoremap <expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"
" Same as Above
"inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "\<Tab>"

" Or use `complete_info` if your vim support it, like:
"inoremap <expr> <Tab> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<Tab>"

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader><F2> <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-s> for select selections ranges, needs server support, like:
" coc-tsserver, coc-python
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Configure highlight color of Coc error signs
highlight link CocErrorSign GruvboxRed

"===Coc-prettier Config===

" Use :Prettier to format current buffer
command! -nargs=0 Prettier :CocCommand prettier.formatFile

"===Coc-yank Config===

" Open yank list history
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

"--------------------------------------------------
" Lightline Config (Coc and fugitive integration)
"--------------------------------------------------
" Resources:
" https://github.com/neoclide/coc.nvim/wiki/Statusline-integration

" NOTES: When uninstalled, set back to showmode to see status line modes
set noshowmode
let g:lightline = {
  \ 'colorscheme': 'powerline',
  \ 'component': {
  \   'lineinfo': '%3l:%-2v',
  \ },
  \ 'component_function': {
  \   'cocstatus': 'coc#status',
  \   'currentfunction': 'CocCurrentFunction',
  \   'readonly': 'LightlineReadonly',
  \   'fugitive': 'LightlineFugitive',
  \   'gutentags': 'gutentags#statusline',
  \   'method' : 'NearestMethodOrFunction'
  \ },
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' },
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'fugitive',
  \               'readonly', 'filename', 'modified' ],
  \             [ 'cocstatus', 'method' ] ],
  \  'right': [ [ 'percent', 'lineinfo' ],
  \            [ 'currentfunction' ], [ 'gutentags' ] ]
  \ },
  \ }

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

function! LightlineReadonly()
	return &readonly ? '' : ''
endfunction

function! LightlineFugitive()
	if exists('*fugitive#head')
	  let branch = fugitive#head()
	  return branch !=# '' ? ''.branch : ''
	endif
	return ''
endfunction

" Gutentags Statusline
augroup MyGutentagsStatusLineRefresher
	autocmd!
	autocmd User GutentagsUpdating call lightline#update()
	autocmd User GutentagsUpdated call lightline#update()
augroup END

" Vista Statusline

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

"--------------------------------------------------
" Git Gutter Config
"--------------------------------------------------

let g:gitgutter_map_keys = 0
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▏'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_modified_removed = '▋'

"--------------------------------------------------
" Easy Git Config
"--------------------------------------------------

let g:easygit_enable_command = 1

" Easy git commands

"Gcd - make vim cd to git root directory.
"Glcd - make vim lcd to git root directory.
"Gblame - Git blame current file, you can use p to preview commit and d to diff with current file.
"GcommitCurrent - Git commit current file with message as command args.
"GdiffThis - Side by side diff of current file with head or any ref.
"Gcommit - Git commit with command line argument.
"Gedit - Edit git reference from git show.
"Gdiff - Git diff with command line argument.
"Gremove - Git remove with command line argument, remove current file when arguments empty.
"Grename - Rename current by git mv, file in buffer list would react the changes.
"Gmove - Git mv with command line argument.
"Gcheckout - Git checkout with command line argument.
"Gpush - Git push with arguments, dispatch when possible.
"Gpull - Git pull with arguments, dispatch when possible.
"Gfetch - Git fetch with arguments, dispatch when possible.
"Gadd - Git add with arguments.
"Gstatus - Show git status in a temporary buffer.
"Ggrep - Git grep repo of current file, and show result in quickfix
"Gmerge - Git merge with branch complete

"--------------------------------------------------
" Buffet Config
"--------------------------------------------------

" Disables lightline tabline
let g:lightline.enable = {
    \ 'statusline': 1,
    \ 'tabline': 0
    \ }

" Resources:
" https://github.com/hardcoreplayers/ThinkVim/blob/master/layers/%2Bui/buffet/config.vim
let g:buffet_tab_icon = "\uf00a"
function! g:BuffetSetCustomColors()
    hi! BuffetCurrentBuffer cterm=NONE ctermbg=106 ctermfg=8 guibg=#b8bb26 guifg=#000000
    hi! BuffetTrunc cterm=bold ctermbg=66 ctermfg=8 guibg=#458588 guifg=#000000
    hi! BuffetBuffer cterm=NONE ctermbg=239 ctermfg=8 guibg=#504945 guifg=#000000
    hi! BuffetTab cterm=NONE ctermbg=66 ctermfg=8 guibg=#458588 guifg=#000000
    hi! BuffetActiveBuffer cterm=NONE ctermbg=10 ctermfg=239 guibg=#999999 guifg=#504945
endfunction

let g:buffet_left_trunc_icon = "\uf0a8"
let g:buffet_right_trunc_icon = "\uf0a9"

nmap <leader>1 <Plug>BuffetSwitch(1)
nmap <leader>2 <Plug>BuffetSwitch(2)
nmap <leader>3 <Plug>BuffetSwitch(3)
nmap <leader>4 <Plug>BuffetSwitch(4)
nmap <leader>5 <Plug>BuffetSwitch(5)
nmap <leader>6 <Plug>BuffetSwitch(6)
nmap <leader>7 <Plug>BuffetSwitch(7)
nmap <leader>8 <Plug>BuffetSwitch(8)
nmap <leader>9 <Plug>BuffetSwitch(9)
nmap <leader>0 <Plug>BuffetSwitch(10)

let g:buffet_max_plug = 10

" Navigate Through buffers
noremap <Tab> :bn<CR>
noremap <S-Tab> :bp<CR>

" Wipe current buffer
noremap <Leader><Tab> :Bw<CR>
noremap <Leader><S-Tab> :Bonly<CR>

let g:buffet_always_show_tabline = 0
let g:buffet_use_devicons = 1
let g:buffet_separator = ""
let g:buffet_show_index = 1

"--------------------------------------------------
" NerdTree Config
"--------------------------------------------------

let g:NERDTreeShowHidden= 1
let g:NERDTreeAutoDeleteBuffer= 1
let g:NERDTreeQuitOnOpen= 1
let g:NERDTreeHijackNetrw = 0
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeCascadeOpenSingleChildDir = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

"let NERDTreeIgnore=['^node_modules$[[dir]]', '^env$[[dir]]', '^__[[dir]]', '^.git$[[dir]]']

" Open nerd tree at the current file or close nerd tree if pressed again.
nnoremap <silent> <expr> <Leader>nc g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"

 "Open NerdTree from root directory
nnoremap <leader>nn :NERDTreeToggle<CR>

"" sync open file with NERDTree
"" " Check if NERDTree is open or active
"function! IsNERDTreeOpen()
  "return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
"endfunction

"" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
"" file, and we're not in vimdiff
"function! SyncTree()
  "if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    "NERDTreeFind
    "wincmd p
  "endif
"endfunction

"" Highlight currently open buffer in NERDTree
"autocmd BufEnter * call SyncTree()

"--------------------------------------------------
" NerdTree Git Plugin Config
"--------------------------------------------------

let g:NERDTreeIndicatorMapCustom = {
  \ "Modified"  : "✹",
  \ "Staged"    : "✚",
  \ "Untracked" : "✭",
  \ "Renamed"   : "➜",
  \ "Unmerged"  : "",
  \ "Deleted"   : "✖",
  \ "Dirty"     : "✗",
  \ "Clean"     : "✔︎",
  \ 'Ignored'   : '☒',
  \ "Unknown"   : "?"
  \ }

"--------------------------------------------------
" NerdTree Syntax Highlight Config
"--------------------------------------------------

let s:brown = "905532"
let s:aqua =  "3AFFDB"
let s:blue = "689FB6"
let s:darkBlue = "44788E"
let s:purple = "834F79"
let s:lightPurple = "834F79"
let s:red = "AE403F"
let s:beige = "F5C06F"
let s:yellow = "F09F17"
let s:orange = "D4843E"
let s:darkOrange = "F16529"
let s:pink = "CB6F6F"
let s:salmon = "EE6E73"
let s:green = "8FAA54"
let s:lightGreen = "31B53E"
let s:white = "FFFFFF"
let s:rspec_red = 'FE405F'
let s:git_orange = 'F54D27'

let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name

let g:NERDTreeExtensionHighlightColor = {} " this line is needed to avoid error
let g:NERDTreeExtensionHighlightColor['css'] = s:blue " sets the color of css files to blue

let g:NERDTreeExactMatchHighlightColor = {} " this line is needed to avoid error
let g:NERDTreeExactMatchHighlightColor['.gitignore'] = s:git_orange " sets the color for .gitignore files

let g:NERDTreePatternMatchHighlightColor = {} " this line is needed to avoid error
let g:NERDTreePatternMatchHighlightColor['.*_spec\.rb$'] = s:rspec_red " sets the color for files ending with _spec.rb

" Limit syntax highlighting to reduce lag
let g:NERDTreeLimitedSyntax = 1


"--------------------------------------------------
" Defx Config
"--------------------------------------------------
" Resources:
" https://github.com/hardcoreplayers/ThinkVim
" https://github.com/hardcoreplayers/ThinkVim/blob/master/layers/%2Bui/defx/config.vim
" https://github.com/rafi/vim-config
" https://github.com/rafi/vim-config/blob/master/config/plugins/defx.vim

nnoremap <silent> <Leader>ee
	\ :<C-u>Defx -resume -toggle -buffer-name=tab`tabpagenr()`<CR>
nnoremap <silent> <Leader>ea
	\ :<C-u>Defx -resume -buffer-name=tab`tabpagenr()` -search=`expand('%:p')`<CR>


call defx#custom#option('_', {
      \ 'winwidth': 30,
      \ 'split': 'vertical',
      \ 'direction': 'topleft',
      \ 'show_ignored_files': 0,
      \ 'columns': 'indent:git:icon:icons:filename',
      \ 'ignored_files':
      \     '.mypy_cache,.pytest_cache,.git,.hg,.svn,.stversions'
      \   . ',__pycache__,.sass-cache,*.egg-info,.DS_Store,*.pyc'
      \	  . ',node_modules,.eslintrc.*,tags,tags.*,package.json'
      \	  . ',package-lock.json,env,.root'
      \ })
      "\ 'listed': 1,

call defx#custom#column('icon', {
      \ 'directory_icon': '▸',
      \ 'opened_icon': '▾',
      \ 'root_icon': ' ',
      \ })

call defx#custom#column('mark', {
      \ 'readonly_icon': '',
      \ 'selected_icon': '✓'
      \ })

" defx-icons plugin
let g:defx_icons_column_length = 2
let g:defx_icons_mark_icon = '✓'

" Internal use
let s:original_width = get(get(defx#custom#_get().option, '_'), 'winwidth')

" Events
" ---

augroup user_plugin_defx
	autocmd!

	" Delete defx if it's the only buffer left in the window
	autocmd WinEnter * if &filetype == 'defx' && winnr('$') == 1 | bdel | endif

	" Move focus to the next window if current buffer is defx
	autocmd TabLeave * if &filetype == 'defx' | wincmd w | endif

	" autocmd TabClosed * call <SID>defx_close_tab(expand('<afile>'))

	" Automatically refresh opened Defx windows when changing working-directory
	autocmd DirChanged * call <SID>defx_handle_dirchanged(v:event)

	" Define defx window mappings
	autocmd FileType defx call <SID>defx_mappings()

augroup END

" Internal functions
" ---

" Deprecated after disabling defx's (buf)listed
" function! s:defx_close_tab(tabnr)
" 	" When a tab is closed, find and delete any associated defx buffers
" 	for l:nr in tabpagebuflist()
" 		if getbufvar(l:nr, '&filetype') ==# 'defx'
" 			silent! execute 'bdelete '.l:nr
" 			break
" 		endif
" 	endfor
" endfunction

function! s:defx_toggle_tree() abort
	" Open current file, or toggle directory expand/collapse
	if defx#is_directory()
		return defx#do_action('open_or_close_tree')
	endif
	return defx#do_action('multi', ['drop', 'quit'])
endfunction

function! s:defx_handle_dirchanged(event)
	" Refresh opened Defx windows when changing working-directory
	let l:cwd = get(a:event, 'cwd', '')
	let l:scope = get(a:event, 'scope', '')   " global, tab, window
	let l:current_win = winnr()
	if &filetype ==# 'defx' || empty(l:cwd) || empty(l:scope)
		return
	endif

	" Find tab-page's defx window
	for l:nr in tabpagebuflist()
	  if getbufvar(l:nr, '&filetype') ==# 'defx'
	    let l:winnr = bufwinnr(l:nr)
	    if l:winnr != -1
	      " Change defx's window directory location
	      if l:scope ==# 'window'
		      execute 'noautocmd' l:winnr . 'windo' 'lcd' l:cwd
	      else
		      execute 'noautocmd' l:winnr . 'wincmd' 'w'
	      endif
	      call defx#call_action('cd', [ l:cwd ])
	      execute 'noautocmd' l:current_win . 'wincmd' 'w'
	      break
	    endif
	  endif
	endfor
endfunction

function! s:jump_dirty(dir) abort
	" Jump to the next position with defx-git dirty symbols
	let l:icons = get(g:, 'defx_git_indicators', {})
	let l:icons_pattern = join(values(l:icons), '\|')

	if ! empty(l:icons_pattern)
	  let l:direction = a:dir > 0 ? 'w' : 'bw'
	  return search(printf('\(%s\)', l:icons_pattern), l:direction)
	endif
endfunction

function! s:defx_mappings() abort
	" Defx window keyboard mappings
	setlocal signcolumn=no expandtab

	nnoremap <silent><buffer><expr> <CR>  <SID>defx_toggle_tree()
	nnoremap <silent><buffer><expr> e     <SID>defx_toggle_tree()
	nnoremap <silent><buffer><expr> l     <SID>defx_toggle_tree()
	nnoremap <silent><buffer><expr> h     defx#do_action('close_tree')
	nnoremap <silent><buffer><expr> t     defx#do_action('open_tree_recursive')
	nnoremap <silent><buffer><expr> st    defx#do_action('multi', [['drop', 'tabnew'], 'quit'])
	nnoremap <silent><buffer><expr> sg    defx#do_action('multi', [['drop', 'vsplit'], 'quit'])
	nnoremap <silent><buffer><expr> sv    defx#do_action('multi', [['drop', 'split'], 'quit'])
	nnoremap <silent><buffer><expr> P     defx#do_action('open', 'pedit')
	nnoremap <silent><buffer><expr> y     defx#do_action('yank_path')
	nnoremap <silent><buffer><expr> x     defx#do_action('execute_system')
	nnoremap <silent><buffer><expr> gx    defx#do_action('execute_system')
	nnoremap <silent><buffer><expr> .     defx#do_action('toggle_ignored_files')

	" Defx's buffer management
	nnoremap <silent><buffer><expr> q      defx#do_action('quit')
	nnoremap <silent><buffer><expr> se     defx#do_action('save_session')
	nnoremap <silent><buffer><expr> <C-r>  defx#do_action('redraw')
	nnoremap <silent><buffer><expr> <C-g>  defx#do_action('print')

	" File/dir management
	nnoremap <silent><buffer><expr><nowait> c  defx#do_action('copy')
	nnoremap <silent><buffer><expr><nowait> m  defx#do_action('move')
	nnoremap <silent><buffer><expr><nowait> p  defx#do_action('paste')
	nnoremap <silent><buffer><expr><nowait> r  defx#do_action('rename')
	nnoremap <silent><buffer><expr><nowait> d  defx#do_action('remove_trash')
	nnoremap <silent><buffer><expr> K  defx#do_action('new_directory')
	nnoremap <silent><buffer><expr> N  defx#do_action('new_multiple_files')

	" Jump
	nnoremap <silent><buffer>  [g :<C-u>call <SID>jump_dirty(-1)<CR>
	nnoremap <silent><buffer>  ]g :<C-u>call <SID>jump_dirty(1)<CR>

	" Change directory
	nnoremap <silent><buffer><expr><nowait> \  defx#do_action('cd', getcwd())
	nnoremap <silent><buffer><expr><nowait> &  defx#do_action('cd', getcwd())
	nnoremap <silent><buffer><expr> <BS>  defx#async_action('cd', ['..'])
	nnoremap <silent><buffer><expr> ~     defx#async_action('cd')
	nnoremap <silent><buffer><expr> u   defx#do_action('cd', ['..'])
	nnoremap <silent><buffer><expr> 2u  defx#do_action('cd', ['../..'])
	nnoremap <silent><buffer><expr> 3u  defx#do_action('cd', ['../../..'])
	nnoremap <silent><buffer><expr> 4u  defx#do_action('cd', ['../../../..'])

	" Selection
	nnoremap <silent><buffer><expr> *  defx#do_action('toggle_select_all')
	nnoremap <silent><buffer><expr><nowait> <Space>
		\ defx#do_action('toggle_select') . 'j'

	nnoremap <silent><buffer><expr> S  defx#do_action('toggle_sort', 'Time')
	nnoremap <silent><buffer><expr> C
		\ defx#do_action('toggle_columns', 'indent:mark:filename:type:size:time')

	" Tools
	nnoremap <silent><buffer><expr> w   defx#do_action('call', '<SID>toggle_width')
	nnoremap <silent><buffer><expr> gd  defx#async_action('multi', ['drop', ['call', '<SID>git_diff']])
	nnoremap <silent><buffer><expr> gr  defx#do_action('call', '<SID>grep')
	nnoremap <silent><buffer><expr> gf  defx#do_action('call', '<SID>find_files')
	if exists('$TMUX')
		nnoremap <silent><buffer><expr> gl  defx#async_action('call', '<SID>explorer')
	endif
endfunction

" TOOLS
" ---

function! s:git_diff(context) abort
	execute 'GdiffThis'
endfunction

function! s:find_files(context) abort
	" Find files in parent directory with Denite
	let l:target = a:context['targets'][0]
	let l:parent = fnamemodify(l:target, ':h')
	silent execute 'wincmd w'
	silent execute 'Denite file/rec:'.l:parent
endfunction

function! s:grep(context) abort
	" Grep in parent directory with Denite
	let l:target = a:context['targets'][0]
	let l:parent = fnamemodify(l:target, ':h')
	silent execute 'wincmd w'
	silent execute 'Denite grep:'.l:parent
endfunction

function! s:toggle_width(context) abort
	" Toggle between defx window width and longest line
	let l:max = 0
	for l:line in range(1, line('$'))
		let l:len = len(getline(l:line))
		let l:max = max([l:len, l:max])
	endfor
	let l:new = l:max == winwidth(0) ? s:original_width : l:max
	call defx#call_action('resize', l:new)
endfunction

function! s:explorer(context) abort
	" Open file-explorer split with tmux
	let l:explorer = s:find_file_explorer()
	if empty('$TMUX') || empty(l:explorer)
		return
	endif
	let l:target = a:context['targets'][0]
	let l:parent = fnamemodify(l:target, ':h')
	let l:cmd = 'split-window -p 30 -c ' . l:parent . ' ' . l:explorer
	silent execute '!tmux ' . l:cmd
endfunction

function! s:find_file_explorer() abort
	" Detect terminal file-explorer
	let s:file_explorer = get(g:, 'terminal_file_explorer', '')
	if empty(s:file_explorer)
		for l:explorer in ['lf', 'hunter', 'ranger', 'vifm']
			if executable(l:explorer)
				let s:file_explorer = l:explorer
				break
			endif
		endfor
	endif
	return s:file_explorer
endfunction

"--------------------------------------------------
" Defx Git Config
"--------------------------------------------------

call defx#custom#column('git', 'indicators', {
  \ 'Modified'  : '✹',
  \ 'Staged'    : '✚',
  \ 'Untracked' : 'ᵁ',
  \ 'Renamed'   : '➜',
  \ 'Unmerged'  : '≠',
  \ 'Ignored'   : 'ⁱ',
  \ 'Deleted'   : '✖',
  \ 'Unknown'   : '⁇'
  \ })

hi Defx_git_Untracked guifg=#FF0000

"--------------------------------------------------
" Denite Config
"--------------------------------------------------
" Resources:
" https://github.com/hardcoreplayers/ThinkVim/blob/master/layers/%2Bcompletion/denite/%2Bdenite_menu.vim
" https://github.com/hardcoreplayers/ThinkVim/blob/master/layers/%2Bcompletion/denite/config.vim
" https://github.com/hardcoreplayers/ThinkVim/blob/master/layers/%2Bthinkvim/config.vim

call denite#custom#option('_', {
		\ 'cached_filter': v:true,
		\ 'cursor_shape': v:true,
		\ 'cursor_wrap': v:true,
		\ 'highlight_filter_background': 'DeniteFilter',
		\ 'highlight_matched_char': 'Underlined',
		\ 'matchers': 'matcher/fuzzy',
		\ 'prompt': 'λ ',
		\ 'split': 'floating',
		\ 'start_filter': v:false,
		\ 'statusline': v:false,
		\ })

function! s:denite_detect_size() abort
    let s:denite_winheight = 20
    let s:denite_winrow = &lines > s:denite_winheight ? (&lines - s:denite_winheight) / 2 : 0
    let s:denite_winwidth = &columns > 240 ? &columns / 2 : 120
    let s:denite_wincol = &columns > s:denite_winwidth ? (&columns - s:denite_winwidth) / 2 : 0
    call denite#custom#option('_', {
         \ 'wincol': s:denite_wincol,
         \ 'winheight': s:denite_winheight,
         \ 'winrow': s:denite_winrow,
         \ 'winwidth': s:denite_winwidth,
         \ })
  endfunction
   augroup denite-detect-size
    autocmd!
    autocmd VimResized * call <SID>denite_detect_size()
  augroup END
  call s:denite_detect_size()


call denite#custom#option('search', { 'start_filter': 0, 'no_empty': 1 })
call denite#custom#option('list', { 'start_filter': 0 })
call denite#custom#option('jump', { 'start_filter': 0 })
call denite#custom#option('git', { 'start_filter': 0 })
call denite#custom#option('mpc', { 'winheight': 20 })


" MATCHERS
" Default is 'matcher/fuzzy'
call denite#custom#source('tag', 'matchers', ['matcher/substring'])
call denite#custom#source('file/rec', 'matchers', ['matcher/fuzzy'])

if has('nvim') && &runtimepath =~# '\/cpsm'
	call denite#custom#source(
		\ 'buffer,file_mru,file/old,file/rec,grep,mpc,line,neoyank',
		\ 'matchers', ['matcher/cpsm', 'matcher/fuzzy'])
endif


" CONVERTERS
" Default is none
call denite#custom#source(
	\ 'buffer,file_mru,file/old,file/rec,directory/rec,directory_mru',
	\ 'converters', ['devicons_denite_converter','converter_relative_word'])

" FIND and GREP COMMANDS
if executable('ag')
	" The Silver Searcher
	call denite#custom#var('file/rec', 'command',
		\ ['ag', '-U', '--hidden', '--follow', '--nocolor', '--nogroup', '-g', ''])

	" Setup ignore patterns in your .agignore file!
	" https://github.com/ggreer/the_silver_searcher/wiki/Advanced-Usage

	call denite#custom#var('grep', 'command', ['ag'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', [])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])
	call denite#custom#var('grep', 'default_opts',
		\ [ '--skip-vcs-ignores', '--vimgrep', '--smart-case', '--hidden' ])

elseif executable('ack')
	" Ack command
	call denite#custom#var('grep', 'command', ['ack'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', ['--match'])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])
	call denite#custom#var('grep', 'default_opts',
			\ ['--ackrc', $HOME.'/.config/ackrc', '-H',
			\ '--nopager', '--nocolor', '--nogroup', '--column'])

elseif executable('rg')
	" Ripgrep
  call denite#custom#var('file/rec', 'command',
        \ ['rg', '--files', '--glob', '!.git'])
  call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'default_opts',
        \ ['-i', '--vimgrep', '--no-heading'])
endif


" KEY MAPPINGS
autocmd FileType denite call s:denite_settings()
function! s:denite_settings() abort
	highlight! link CursorLine Visual
	nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
	nnoremap <silent><buffer><expr> i    denite#do_map('open_filter_buffer')
	nnoremap <silent><buffer><expr> d    denite#do_map('do_action', 'delete')
	nnoremap <silent><buffer><expr> p    denite#do_map('do_action', 'preview')
	nnoremap <silent><buffer><expr> st   denite#do_map('do_action', 'tabopen')
	nnoremap <silent><buffer><expr> sv   denite#do_map('do_action', 'vsplit')
	nnoremap <silent><buffer><expr> si   denite#do_map('do_action', 'split')
	nnoremap <silent><buffer><expr> '    denite#do_map('quick_move')
	nnoremap <silent><buffer><expr> q    denite#do_map('quit')
	nnoremap <silent><buffer><expr> r    denite#do_map('redraw')
	nnoremap <silent><buffer><expr> yy   denite#do_map('do_action', 'yank')
	nnoremap <silent><buffer><expr> <Esc>   denite#do_map('quit')
	nnoremap <silent><buffer><expr> <C-u>   denite#do_map('restore_sources')
	nnoremap <silent><buffer><expr> <C-f>   denite#do_map('do_action', 'defx')
	nnoremap <silent><buffer><expr> <C-x>   denite#do_map('choose_action')
	nnoremap <silent><buffer><expr><nowait> <Space> denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_settings()
function! s:denite_filter_settings() abort
	nnoremap <silent><buffer><expr> <Esc>  denite#do_map('quit')
	" inoremap <silent><buffer><expr> <Esc>  denite#do_map('quit')
	nnoremap <silent><buffer><expr> q      denite#do_map('quit')
	imap <silent><buffer> <C-c> <Plug>(denite_filter_quit)
	"inoremap <silent><buffer><expr> <C-c>  denite#do_map('quit')
	nnoremap <silent><buffer><expr> <C-c>  denite#do_map('quit')
	inoremap <silent><buffer>       kk     <Esc><C-w>p
	nnoremap <silent><buffer>       kk     <C-w>p
	inoremap <silent><buffer>       jj     <Esc><C-w>p
	nnoremap <silent><buffer>       jj     <C-w>p
endfunction

" Denite Menu Settings

let s:menus = {}

let s:menus.dein = { 'description': '⚔️  Plugin management' }
let s:menus.dein.command_candidates = [
  \   ['🐬 Dein: Plugins update       🔸', 'call dein#update()'],
  \   ['🐬 Dein: Plugins List         🔸', 'Denite dein'],
  \   ['🐬 Dein: RecacheRuntimePath   🔸', 'call dein#recache_runtimepath()'],
  \   ['🐬 Dein: Update log           🔸', 'echo dein#get_updates_log()'],
  \   ['🐬 Dein: Log                  🔸', 'echo dein#get_log()'],
  \ ]

let s:menus.project = { 'description': '🛠  Project & Structure' }
let s:menus.project.command_candidates = [
  \   ['🐳 File Explorer        🔸<Leader>e',        'Defx -resume -toggle -buffer-name=tab`tabpagenr()`<CR>'],
  \   ['🐳 Outline              🔸<LocalLeader>t',   'TagbarToggle'],
  \   ['🐳 Git Status           🔸<LocalLeader>gs',  'Denite gitstatus'],
  \   ['🐳 Mundo Tree           🔸<Leader>m',  'MundoToggle'],
  \ ]

let s:menus.files = { 'description': '📁 File tools' }
let s:menus.files.command_candidates = [
  \   ['📂 Denite: Find in files…    🔹 ',  'Denite grep:.'],
  \   ['📂 Denite: Find files        🔹 ',  'Denite file/rec'],
  \   ['📂 Denite: Buffers           🔹 ',  'Denite buffer'],
  \   ['📂 Denite: MRU               🔹 ',  'Denite file/old'],
  \   ['📂 Denite: Line              🔹 ',  'Denite line'],
  \ ]

let s:menus.tools = { 'description': '⚙️  Dev Tools' }
let s:menus.tools.command_candidates = [
  \   ['🐠 Git commands       🔹', 'Git'],
  \   ['🐠 Git log            🔹', 'Denite gitlog:all'],
  \   ['🐠 Goyo               🔹', 'Goyo'],
  \   ['🐠 Tagbar             🔹', 'TagbarToggle'],
  \   ['🐠 File explorer      🔹', 'Defx -resume -toggle -buffer-name=tab`tabpagenr()`<CR>'],
  \ ]

let s:menus.config = { 'description': '🔧 Zsh Tmux Configuration' }
let s:menus.config.file_candidates = [
  \   ['🐠 Zsh Configurationfile            🔸', '~/.zshrc'],
  \   ['🐠 Tmux Configurationfile           🔸', '~/.tmux.conf'],
  \ ]

let s:menus.thinkvim = {'description': '💎 ThinkVim Configuration files'}
let s:menus.thinkvim.file_candidates = [
  \   ['🐠 MainVimrc          settings: vimrc               🔹', $VIMPATH.'/core/vimrc'],
  \   ['🐠 Initial            settings: init.vim            🔹', $VIMPATH.'/core/init.vim'],
  \   ['🐠 General            settings: general.vim         🔹', $VIMPATH.'/core/general.vim'],
  \   ['🐠 DeinConfig         settings: deinrc.vim          🔹', $VIMPATH.'/core/deinrc.vim'],
  \   ['🐠 FileTypes          settings: filetype.vim        🔹', $VIMPATH.'/core/filetype.vim'],
  \   ['🐠 Installed       LoadPlugins: plugins.yaml        🔹', $VIMPATH.'/core/dein/plugins.yaml'],
  \   ['🐠 Installed      LocalPlugins: local_plugins.yaml  🔹', $VIMPATH.'/core/dein/local_plugins.yaml'],
  \   ['🐠 Global   Key    Vimmappings: mappings.vim        🔹', $VIMPATH.'/core/mappings.vim'],
  \   ['🐠 Global   Key Pluginmappings: Pluginmappings      🔹', $VIMPATH.'/core/plugins/allkey.vim'],
  \ ]

call denite#custom#var('menu', 'menus', s:menus)

"let s:menus.sessions = { 'description': 'Sessions' }
"let s:menus.sessions.command_candidates = [
  "\   ['▶ Restore session │ ;s', 'Denite session'],
  "\   ['▶ Save session…   │', 'Denite session/new'],
  "\ ]

" Editor Denite Key Mappings
nnoremap <silent><Leader>d :<C-u>Denite menu<CR>
noremap zl :<C-u>call <SID>my_denite_outline(&filetype)<CR>
noremap zL :<C-u>call <SID>my_denite_decls(&filetype)<CR>
noremap zT :<C-u>call <SID>my_denite_file_rec_goroot()<CR>

nnoremap <silent> <Leader>gl :<C-u>Denite gitlog:all<CR>
    nnoremap <silent> <Leader>gh :<C-u>Denite gitbranch<CR>
function! s:my_denite_outline(filetype) abort
execute 'Denite' a:filetype ==# 'go' ? "decls:'%:p'" : 'outline'
endfunction
function! s:my_denite_decls(filetype) abort
if a:filetype ==# 'go'
    Denite decls
else
    call denite#util#print_error('decls does not support filetypes except go')
endif
endfunction
function! s:my_denite_file_rec_goroot() abort
if !executable('go')
    call denite#util#print_error('`go` executable not found')
    return
endif
let out = system('go env | grep ''^GOROOT='' | cut -d\" -f2')
let goroot = substitute(out, '\n', '', '')
call denite#start(
	\ [{'name': 'file/rec', 'args': [goroot]}],
	\ {'input': '.go'})
endfunction

"--------------------------------------------------
" Comfortable Motion Config
"--------------------------------------------------

let g:comfortable_motion_interval = 1000.0/80  " Default: 1000.0/60
let g:comfortable_motion_friction = 180.0       " Default: 80
let g:comfortable_motion_air_drag = 1.0        " Default: 2.0

" Scrolling configuration proportional to the window height
let g:comfortable_motion_no_default_key_mappings = 1
let g:comfortable_motion_impulse_multiplier = 1.5  " Feel free to increase/decrease this value.
nnoremap <silent> <C-d> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 2)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -2)<CR>
nnoremap <silent> <C-f> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 4)<CR>
nnoremap <silent> <C-b> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -4)<CR>

"--------------------------------------------------
" Accelerated jk Config
"--------------------------------------------------

" conservative deceleration
let g:accelerated_jk_enable_deceleration = 1

" if default key-repeat interval check(150 ms) is too short
let g:accelerated_jk_acceleration_limit = 250

" Time-driven acceleration
"nmap j <Plug>(accelerated_jk_gj)
"nmap k <Plug>(accelerated_jk_gk)

" Position-driven acceleration
nmap j <Plug>(accelerated_jk_gj_position)
nmap k <Plug>(accelerated_jk_gk_position)

"--------------------------------------------------
" Easy Align Config
"--------------------------------------------------

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"--------------------------------------------------
" Indent Guides Config
"--------------------------------------------------

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes =
    \ ['help', 'terminal', 'defx', 'denite', 'nerdtree',
    \ 'startify', 'tagbar', 'vista_kind', 'vista', 'fzf']
let g:indent_guides_color_change_percent = 10

"--------------------------------------------------
" Goyo Config
"--------------------------------------------------

function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  Limelight
  " ...
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=7
  Limelight!
  " ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Toggle Goyo on and off
map <leader>z :Goyo<CR>

let g:goyo_width = 80
let g:goyo_height = 90
let g:goyo_linenr = 1

"--------------------------------------------------
" Limelight Config
"--------------------------------------------------

" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

" Color name (:help gui-colors) or RGB color
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_guifg = '#777777'

" Default: 0.5
let g:limelight_default_coefficient = 0.7

" Number of preceding/following paragraphs to include (default: 0)
let g:limelight_paragraph_span = 8

" Beginning/end of paragraph
"   When there's no empty line between the paragraphs
"   and each paragraph starts with indentation
let g:limelight_bop = '^\s'
let g:limelight_eop = '\ze\n^\s'

" Highlighting priority (default: 10)
"   Set it to -1 not to overrule hlsearch
let g:limelight_priority = -1

"--------------------------------------------------
" Rooter Config
"--------------------------------------------------

" Change directory for the current window only
let g:rooter_use_lcd = 1

" Resolve symbolic link
let g:rooter_resolve_links = 1

" Stop echoing project directory
let g:rooter_silent_chdir = 1

"--------------------------------------------------
" Vim-test Config
"--------------------------------------------------

" Strategies Resource: https://github.com/janko/vim-test#strategies
let test#strategy = {
  \ 'nearest': 'neovim',
  \ 'file':    'dispatch',
  \ 'suite':   'basic',
\}

" Terminal position when neovim test strategy is used
let test#neovim#term_position = "topleft"

"--------------------------------------------------
" Vimux Config
"--------------------------------------------------

" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>

" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>

" Inspect runner pane
map <Leader>vi :VimuxInspectRunner<CR>

" Close vim tmux runner opened by VimuxRunCommand
map <Leader>vq :VimuxCloseRunner<CR>

" Interrupt any command running in the runner pane
map <Leader>vx :VimuxInterruptRunner<CR>

" Zoom the runner pane (use <bind-key> z to restore runner pane)
map <Leader>vz :call VimuxZoomRunner()<CR>

" Split pane direction orientation
let g:VimuxOrientation = "v"    " Horizontal (defailt: v)

"--------------------------------------------------
" Bracey Config
"--------------------------------------------------

" NOTE: Plugin is installed in .vimrc using Vim-plug plugin manager.
"	Dein plugin manager not working

let g:bracey_refresh_on_save= 1
let g:bracey_eval_on_save = 1         " Re-evaluate JavaScript on save
let g:bracey_auto_start_browser= 1
"let g:bracey_browser_command='chrome'
let g:bracey_server_port=5050
"let g:bracey_server_path='https://localhost'
auto FileType html,css,javascript map <leader>bo :Bracey<CR>
auto FileType html,css,javascript map <leader>bs :BraceyStop<CR>
auto FileType html,css,javascript map <leader>br :BraceyReload<CR>

"--------------------------------------------------
" Gutentags Config
"--------------------------------------------------
" Gutentags Guide: https://www.reddit.com/r/vim/comments/d77t6j/guide_how_to_setup_ctags_with_gutentags_properly/

let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
let g:gutentags_project_root = ['.root', '.git', '.svn', '.hg',
  \ '.project', 'package.json']
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_exclude_filetypes = ['defx', 'denite', 'vista']
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \ ]

"let g:gutentags_ctags_extra_args = ['--output-format=e-ctags']

"let g:gutentags_ctags_exclude = ['*.json', '*.js', '*.ts', '*.jsx',
  "\ '*.css', '*.less', '*.sass', '*.go', '*.dart', 'node_modules',
  "\ 'dist', 'vendor']

let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]

" use GutentagsClearCache to clear ctags cache quickly
command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')

"--------------------------------------------------
" Fzf Config
"--------------------------------------------------

nnoremap <leader>ff :call Fzf_dev()<CR>
nnoremap <leader>fF :Files!<CR>
nnoremap <leader>Ff :FZF<CR>
nnoremap <leader>FF :FZF!<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fw :Windows<CR>
nnoremap <leader>ft :Tags<CR>
nnoremap <leader>fT :BTags<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>fL :BLines<CR>
nnoremap <leader>fc :Commits<CR>
nnoremap <leader>fL :BCommits<CR>

" Using Rgrep with fzf
if executable('rg')
  "let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  let $FZF_DEFAULT_COMMAND = 'fd --type f --follow --exclude .git --exclude node_modules --exclude env --exclude __pycache__ --color=always'
  set grepprg=rg\ --vimgrep

  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, 'number', 'no')

  let height = float2nr(&lines/2)
  let width = float2nr(&columns - (&columns * 2 / 10))
  "let width = &columns
  let row = float2nr(&lines / 3)
  let col = float2nr((&columns - width) / 3)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': row,
        \ 'col': col,
        \ 'width': width,
        \ 'height':height,
        \ }
  let win =  nvim_open_win(buf, v:true, opts)
  call setwinvar(win, '&number', 0)
  call setwinvar(win, '&relativenumber', 0)
endfunction

let g:fzf_commits_log_options = '--graph --color=always
  \ --format="%C(yellow)%h%C(red)%d%C(reset)
  \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

function! Fzf_dev()
  let l:fzf_files_options = ' -m --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up --preview "bat --color always --style numbers {2..}"'

    function! s:files()
      let l:files = split(system($FZF_DEFAULT_COMMAND), '\n')
      return s:prepend_icon(l:files)
    endfunction

    function! s:prepend_icon(candidates)
      let result = []
      for candidate in a:candidates
	let filename = fnamemodify(candidate, ':p:t')
	let icon = WebDevIconsGetFileTypeSymbol(filename, isdirectory(filename))
	call add(result, printf("%s %s", icon, candidate))
      endfor

      return result
    endfunction

    function! s:edit_file(items)
      let items = a:items
      let i = 1
      let ln = len(items)
      while i < ln
	let item = items[i]
	let parts = split(item, ' ')
	let file_path = get(parts, 1, '')
	let items[i] = file_path
	let i += 1
      endwhile
      call s:Sink(items)
    endfunction

    let opts = fzf#wrap({})
    let opts.source = <sid>files()
    let s:Sink = opts['sink*']
    let opts['sink*'] = function('s:edit_file')
    let opts.options .= l:fzf_files_options
    call fzf#run(opts)
endfunction

"--------------------------------------------------
" Tagbar Config
"--------------------------------------------------

nnoremap <silent> <leader>tb :TagbarToggle<CR>
let g:tagbar_width = 35

"--------------------------------------------------
" Markdown Preview Config
"--------------------------------------------------

nmap <leader>md <Plug>MarkdownPreviewToggle
nmap <leader>mo <Plug>MarkdownPreview
nmap <leader>mc <Plug>MarkdownPreviewStop

let g:mkdp_auto_close = 0
let g:mkdp_auto_start = 0
let g:mkdp_command_for_global = 1
let g:mkdp_markdown_css = "/home/marklcrns/.local/lib/github-markdown-css/github-markdown.css"

"--------------------------------------------------
" Easy motion Config
"--------------------------------------------------

map <localleader> <Plug>(easymotion-prefix)
let g:EasyMotion_do_mapping = 1
let g:EasyMotion_prompt = 'Jump to → '
let g:EasyMotion_keys = 'hklyuiopnm,qwertzxcvbasdgjf;'
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1

"--------------------------------------------------
" Mundo Config
"--------------------------------------------------

nnoremap <silent> <leader>m :MundoToggle<CR>

set undofile
set undodir=~/.vim/undo

let g:mundo_width = 30
let g:mundo_preview_height = 15
let g:mundo_right = 0

"--------------------------------------------------
" Vista Config
"--------------------------------------------------

nnoremap <silent> <Leader>vv :Vista!!<CR>
let g:vista#executives = ['coc', 'ctags', 'lcn', 'vim_lsp']

" How each level is indented and what to prepend.
" This could make the display more compact or more spacious.
" e.g., more compact: ["▸ ", ""]
" Note: this option only works the LSP executives, doesn't work for `:Vista ctags`.
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]

" Executive used when opening vista sidebar without specifying it.
" See all the avaliable executives via `:echo g:vista#executives`.
let g:vista_default_executive = 'ctags'
let g:vista_finder_alternative_executives = ['coc']
let g:vista#finders = 'fzf'

" Set the executive for some filetypes explicitly. Use the explicit executive
" instead of the default one for these filetypes when using `:Vista` without
" specifying the executive.
"let g:vista_executive_for = {
  "\ 'go': 'ctags',
  "\ 'javascript': 'coc',
  "\ 'javascript.jsx': 'coc',
  "\ 'python': 'ctags',
  "\ }

" To enable fzf's preview window set g:vista_fzf_preview.
" The elements of g:vista_fzf_preview will be passed as arguments to fzf#vim#with_preview()
" For example:
let g:vista_fzf_preview = ['right:50%']
let g:vista_sidebar_width = 35
" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 1

" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }

"--------------------------------------------------
" Vim Zoom Config
"--------------------------------------------------

nmap <C-w>f <Plug>(zoom-toggle)

"--------------------------------------------------
" Startify Config
"--------------------------------------------------

autocmd User Startified setlocal cursorline

let g:startify_enable_special      = 0
let g:startify_files_number        = 8
let g:startify_relative_path       = 1
let g:startify_change_to_dir       = 1
let g:startify_update_oldfiles     = 1
let g:startify_session_persistence = 1

let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

" Centering header
let g:startify_custom_header =
	\ startify#center(startify#fortune#cowsay('', '═','║','╔','╗','╝','╚'))

let g:startify_bookmarks = [
	\ { 'v': '~/.vimrc' },
	\ { 'n': '~/.config/nvim/init.vim' },
	\ { 'm': '~/.mutt/muttrc' },
	\ { 'ma': '~/.mail_aliases' },
	\ { 'z': '~/.zshrc' },
	\ { 'b': '~/.bashrc' },
	\ { 'a': '~/.bash_aliases' },
	\ { 't': '~/.tmux.conf' },
	\ ]

"--------------------------------------------------
" Tablet Mode Config
"--------------------------------------------------

function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'

" For Markdown-compatible table use
let g:table_mode_corner='|'
let g:table_mode_corner_corner='+'
let g:table_mode_header_fillchar='='


"======================================================================
" Color settings:
"======================================================================

"--------------------------------------------------
" Gruvbox Color Scheme
"--------------------------------------------------

colorscheme gruvbox

" For Gruvbox to look correct in terminal Vim you'll want to source a palette
" script that comes with the Gruvbox plugin.

" Add this to your ~/.profile file:
"   source "$HOME/.vim/plugged/gruvbox/gruvbox_256palette.sh"

" Gruvbox comes with both a dark and light theme.
set background=dark

" Gruvbox has 'hard', 'medium' (default) and 'soft' contrast options.
let g:gruvbox_contrast_light='soft'

" This needs to come last, otherwise the colors aren't correct.
syntax on

"--------------------------------------------------
" Janah Color Scheme (modified)
"--------------------------------------------------
" Repo: https://github.com/mhinz/vim-janah

" Plugin: vim-startify {{{1
"highlight StartifyBracket guifg=#585858 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
"highlight StartifyFile guifg=#eeeeee ctermfg=255 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
"highlight StartifyFooter guifg=#585858 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
"highlight StartifyHeader guifg=#87df87 ctermfg=114 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
"highlight StartifyNumber guifg=#ffaf5f ctermfg=215 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
"highlight StartifyPath guifg=#8a8a8a ctermfg=245 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
"highlight StartifySection guifg=#dfafaf ctermfg=181 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
"highlight StartifySelect guifg=#5fdfff ctermfg=81 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
"highlight StartifySlash guifg=#585858 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
"highlight StartifySpecial guifg=#585858 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE

" Plugin: vim-easymotion {{{1
highlight EasyMotionTarget guifg=#ffff5f ctermfg=227 guibg=NONE ctermbg=NONE gui=bold cterm=bold
highlight EasyMotionTarget2First guifg=#df005f ctermfg=161 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
highlight EasyMotionTarget2Second guifg=#ffff5f ctermfg=227 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE

" Pmenu {{{1
highlight Pmenu guifg=#e4e4e4 ctermfg=254 guibg=#262626 ctermbg=235 gui=NONE cterm=NONE
highlight PmenuSbar ctermfg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
highlight PmenuSel guifg=#df5f5f ctermfg=167 guibg=#444444 ctermbg=238 gui=bold cterm=bold
highlight PmenuThumb ctermfg=NONE guibg=#df5f5f ctermbg=167 gui=NONE cterm=NONE

" Folds {{{1
highlight foldcolumn ctermfg=102 ctermbg=237 cterm=none guifg=#878787 guibg=#3a3a3a gui=none
highlight folded ctermfg=102 ctermbg=237 cterm=none guifg=#878787 guibg=#3a3a3a gui=none

" Misc {{{1
highlight Comment guifg=#585858 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE

"--------------------------------------------------
" ThinkVim Colors
"--------------------------------------------------
" Repo: https://github.com/hardcoreplayers/ThinkVim/blob/master/core/color.vim

"Pmenu Colors
" ---------------------------------------------------------
"" hi PMenuSel ctermfg=252 ctermbg=15006 guifg=#d0d0d0 guibg=#ba8baf guisp=#ba8baf cterm=NONE gui=NONE
"hi Pmenu ctermfg=103 ctermbg=236 guifg=#9a9aba guibg=#34323e guisp=NONE cterm=NONE gui=NONE
"hi PmenuSbar ctermfg=NONE ctermbg=234 guifg=NONE guibg=#212026 guisp=NONE cterm=NONE gui=NONE
"hi PmenuSel ctermfg=NONE ctermbg=60 guifg=NONE guibg=#5e5079 guisp=NONE cterm=NONE gui=NONE
"hi PmenuThumb ctermfg=NONE ctermbg=60 guifg=NONE guibg=#5d4d7a guisp=NONE cterm=NONE gui=NONE

"GitGutter Coc-git Highlight
" ---------------------------------------------------------
highlight GitGutterAdd ctermfg=22 guifg=#006000 ctermbg=NONE guibg=NONE
highlight GitGutterChange ctermfg=58 guifg=#5F6000 ctermbg=NONE guibg=NONE
highlight GitGutterDelete ctermfg=52 guifg=#600000 ctermbg=NONE guibg=NONE
highlight GitGutterChangeDelete ctermfg=52 guifg=#600000 ctermbg=NONE guibg=NONE

" Defx Highlight
" ---------------------------------------------------------
highlight Defx_filename_3_Modified  ctermfg=1  guifg=#D370A3
highlight Defx_filename_3_Staged    ctermfg=10 guifg=#A3D572
highlight Defx_filename_3_Ignored   ctermfg=8  guifg=#404660
highlight def link Defx_filename_3_Untracked Comment
highlight def link Defx_filename_3_Unknown Comment
highlight def link Defx_filename_3_Renamed Title
highlight def link Defx_filename_3_Unmerged Label
" highlight Defx_git_Deleted   ctermfg=13 guifg=#b294b

" buftabline highlight
" ---------------------------------------------------------
"highlight BufTabLineCurrent ctermbg=96 guibg=#5d4d7a


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

" Auto-resize splits when Vimvgets resized.
autocmd VimResized * wincmd =

" Update a buffer's contents on focus if it changed outside of Vim.
au FocusGained,BufEnter * :checktime










"**********************************************************************
" Scrap Codes: <leader>cu to uncomment -'nerdcommenter'
"**********************************************************************

"--------------------------------------------------
" Plugins: Dein Plugin Manager
"--------------------------------------------------

" Uninstall command
" call map(dein#check_clean(), "delete(v:val, 'rf')")

  "" Auto Completion
  "call dein#add('Shougo/deoplete.nvim',
    "\ { 'do': ':UpdateRemotePlugins' },
    "\ {'on_i': 1})

  "" Auto Completion Sources
  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')
  "call dein#add('wokalski/autocomplete-flow')
  "call dein#add('deoplete-plugins/deoplete-jedi',
    "\ {'on_ft': ['python']})

  "" Debugger
  "call dein#add('vim-vdebug/vdebug')

  " Linter
  "call dein#add('dense-analysis/ale')
  "call dein#add('maximbaz/lightline-ale')  " Ale integrated

  "" Misc
  "call dein#add('Yggdroot/indentLine')
  "call dein#add('xolox/vim-easytags')
  "call dein#add('xolox/vim-misc')
  "call dein#add('jiangmiao/auto-pairs')
  "call dein#add('python-mode/python-mode',
  "call dein#add('kien/rainbow_parentheses.vim')
    "\ { 'on_ft': 'python' })

"--------------------------------------------------
" Ale Config
"--------------------------------------------------
" Resources:
" https://davidtranscend.com/blog/configure-eslint-prettier-vid/
" https://medium.com/@alexlafroscia/writing-js-in-vim-4c971a95fd49

"let g:ale_sign_error = '✘'
"let g:ale_sign_warning = '⚠'
"highlight ALEErrorSign ctermbg=NONE ctermfg=red
"highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
"let g:ale_fixers = {
"\  'javascript': ['eslint'],
"\}
"let g:ale_fix_on_save = 1

"" Ale jump to next and prev error
"nmap <silent> <leader>an :ALENext<cr>
"nmap <silent> <leader>ap :ALEPrevious<cr>

"--------------------------------------------------
" Lighline-ale Config
"--------------------------------------------------

"let g:lightline.component_expand = {
  "\  'linter_checking': 'lightline#ale#checking',
  "\  'linter_warnings': 'lightline#ale#warnings',
  "\  'linter_errors': 'lightline#ale#errors',
  "\  'linter_ok': 'lightline#ale#ok',
  "\ }
"let g:lightline.component_type = {
  "\     'linter_checking': 'left',
  "\     'linter_warnings': 'warning',
  "\     'linter_errors': 'error',
  "\     'linter_ok': 'left',
  "\ }
"" Includes fugitve and ale linter status
"let g:lightline.active = {
	"\ 'left': [ [ 'mode', 'paste' ],
	"\           [ 'fugitive', 'readonly', 'filename', 'modified' ] ],
	"\ 'right': [ [ 'linter_checking', 'linter_errors',
  "\              'linter_warnings', 'linter_ok' ],
  "\            [ 'lineinfo' ],
	"\            [ 'percent' ],
	"\            [ 'fileformat', 'fileencoding', 'filetype' ] ]
  "\ }

"" Lightline custom indicator icons
"let g:lightline#ale#indicator_checking = "\uf110"
"let g:lightline#ale#indicator_warnings = "\uf071"
"let g:lightline#ale#indicator_errors = "\uf05e"
"let g:lightline#ale#indicator_ok = "\uf00c"

"--------------------------------------------------
" Deoplete Config
"--------------------------------------------------

"let g:deoplete#enable_at_startup = 1
"" <TAB>: completion.
""inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"let g:python_host_prog = '/usr/bin/python2.7'
"let g:python3_host_prog = '/usr/local/bin/python3.8'

"" Neosnippet Config:
"let g:neosnippet#enable_completed_snippet = 1

"--------------------------------------------------
" Which Key Config
"--------------------------------------------------

"nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
"vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

""let g:which_key_map['w'] = {
      ""\ 'name' : '+windows' ,
      ""\ 'w' : ['<C-W>w'     , 'other-window']          ,
      ""\ 'd' : ['<C-W>c'     , 'delete-window']         ,
      ""\ '-' : ['<C-W>s'     , 'split-window-below']    ,
      ""\ '|' : ['<C-W>v'     , 'split-window-right']    ,
      ""\ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
      ""\ 'h' : ['<C-W>h'     , 'window-left']           ,
      ""\ 'j' : ['<C-W>j'     , 'window-below']          ,
      ""\ 'l' : ['<C-W>l'     , 'window-right']          ,
      ""\ 'k' : ['<C-W>k'     , 'window-up']             ,
      ""\ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
      ""\ 'J' : ['resize +5'  , 'expand-window-below']   ,
      ""\ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
      ""\ 'K' : ['resize -5'  , 'expand-window-up']      ,
      ""\ '=' : ['<C-W>='     , 'balance-window']        ,
      ""\ 's' : ['<C-W>s'     , 'split-window-below']    ,
      ""\ 'v' : ['<C-W>v'     , 'split-window-below']    ,
      ""\ '?' : ['Windows'    , 'fzf-window']            ,
      ""\ }

"let g:which_key_map =  {}
"let g:which_key_map = {
      "\ 'name' : '+ThinkVim root ' ,
      "\ '1' : 'select window-1'      ,
      "\ '2' : 'select window-2'      ,
      "\ '3' : 'select window-3'      ,
      "\ '4' : 'select window-4'      ,
      "\ '5' : 'select window-5'      ,
      "\ '6' : 'select window-6'      ,
      "\ '7' : 'select window-7'      ,
      "\ '8' : 'select window-8'      ,
      "\ '9' : 'select window-9'      ,
      "\ '0' : 'select window-10'      ,
      "\ 'a' : {
            "\ 'name' : '+coc-code-action',
            "\ 'c' : 'code action',
            "\ },
      "\ 'b' : {
            "\ 'name' : '+buffer',
            "\ 'b' : 'buffer list',
            "\ 'c' : 'keep current buffer',
            "\ 'o' : 'keep input buffer',
            "\ },
      "\ 'e' : 'open file explorer' ,
      "\ '-' : 'choose window by {prompt char}' ,
      "\ 'd' : 'search cursor word on Dash.app' ,
      "\ 'G' : 'distraction free writing' ,
      "\ 'F' : 'find current file' ,
      "\ 'f' : {
            "\ 'name' : '+search {files cursorword word outline}',
            "\ 'f' : 'find file',
            "\ 'r' : 'search {word}',
            "\ 'c' : 'change colorscheme',
            "\ 'w' : 'search cursorword',
            "\ 'v' : 'search outline',
            "\ },
      "\ 'm' : 'open mundotree' ,
      "\ 'w' : 'save file',
      "\ 'j' : 'open coc-explorer',
      "\ 's' : 'open startify screen',
      "\ 'p' : 'edit pluginsconfig {filename}',
      "\ 'x' : 'coc cursors operate',
      "\ 'g'  :{
                "\'name':'+git-operate',
                "\ 'd'    : 'Gdiff',
                "\ 'c'    : 'Gcommit',
                "\ 'b'    : 'Gblame',
                "\ 'B'    : 'Gbrowse',
                "\ 'S'    : 'Gstatus',
                "\ 'p'    : 'git push',
                "\ 'l'    : 'GitLogAll',
                "\ 'h'    : 'GitBranch',
                "\},
      "\ 'c'    : {
              "\ 'name' : '+coc list' ,
              "\ 'a'    : 'coc CodeActionSelected',
              "\ 'd'    : 'coc Diagnostics',
              "\ 'c'    : 'coc Commands',
              "\ 'e'    : 'coc Extensions',
              "\ 'j'    : 'coc Next',
              "\ 'k'    : 'coc Prev',
              "\ 'o'    : 'coc OutLine',
              "\ 'r'    : 'coc Resume',
              "\ 'n'    : 'coc Rename',
              "\ 's'    : 'coc Isymbols',
              "\ 'g'    : 'coc Gitstatus',
              "\ 'f'    : 'coc Format',
              "\ 'm'    : 'coc search word to multiple cursors',
              "\ },
      "\ 'q' : {
            "\ 'name' : '+coc-quickfix',
            "\ 'f' : 'coc fixcurrent',
            "\ },
      "\ 't' : {
            "\ 'name' : '+tab-operate',
            "\ 'n' : 'new tab',
            "\ 'e' : 'edit tab',
            "\ 'm' : 'move tab',
            "\ },
      "\ }

"let g:which_key_map[' '] = {
      "\ 'name' : '+easymotion-jumpto-word ' ,
      "\ 'b' : ['<plug>(easymotion-b)' , 'beginning of word backward'],
      "\ 'f' : ['<plug>(easymotion-f)' , 'find {char} to the left'],
      "\ 'w' : ['<plug>(easymotion-w)' , 'beginning of word forward'],
      "\ }

"let g:which_key_localmap ={
      "\ 'name' : '+LocalLeaderKey'  ,
      "\ 'v'    : 'open vista show outline',
      "\ 'r'    : 'quick run',
      "\ 'm'    : 'toolkit Menu',
      "\ 'g' : {
            "\ 'name' : '+golang-toolkit',
            "\ 'i'    : 'go impl',
            "\ 'd'    : 'go describe',
            "\ 'c'    : 'go callees',
            "\ 'C'    : 'go callers',
            "\ 's'    : 'go callstack',
            "\ },
      "\ }

"let g:which_key_rsbgmap = {
      "\ 'name' : '+RightSquarebrackets',
      "\ 'a'    : 'ale nextwarp',
      "\ 'c'    : 'coc nextdiagnostics',
      "\ 'b'    : 'next buffer',
      "\ 'g'    : 'coc gitnextchunk',
      "\ ']'    : 'jump prefunction-golang',
      "\ }


"let g:which_key_lsbgmap = {
      "\ 'name' : '+LeftSquarebrackets',
      "\ 'a'    : 'ale prewarp',
      "\ 'c'    : 'coc prediagnostics',
      "\ 'b'    : 'pre buffer',
      "\ 'g'    : 'coc gitprevchunk',
      "\ '['    : 'jump nextfunction-golang',
      "\ }

"call which_key#register('<Space>', 'g:which_key_map')
"call which_key#register(';', 'g:which_key_localmap')
"call which_key#register(']', 'g:which_key_rsbgmap')
"call which_key#register('[', 'g:which_key_lsbgmap')

"--------------------------------------------------
" IndentLine Config
"--------------------------------------------------

"let g:indentline_char='▸'
"let g:indentLine_char_list = ['▸']
"let g:indentLine_color_term = 239
"let g:indentLine_concealcursor = 'niv'
"let g:indentLine_color_gui= '#725972'
"let g:vim_json_syntax_conceal = 1    " hide json file quotes
"let g:indentLine_faster = 1
"let g:indentLine_bufTypeExclude =
    "\ ['help', 'terminal', 'defx', 'denite', 'nerdtree',
    "\ 'startify', 'tagbar', 'vista_kind', 'vista', 'nofile']
"let g:indentLine_bufNameExclude =
    "\ ['_.*', '\[defx\]*']
"let g:indentLine_fileTypeExclude = ['text', 'sh', 'defx']
"let g:indentLine_faster = 1     " May cause some issue

"--------------------------------------------------
" Rainbow Parentheses
"--------------------------------------------------

"let g:rbpt_colorpairs = [
    "\ ['brown',       'RoyalBlue3'],
    "\ ['Darkblue',    'SeaGreen3'],
    "\ ['darkgray',    'DarkOrchid3'],
    "\ ['darkgreen',   'firebrick3'],
    "\ ['darkcyan',    'RoyalBlue3'],
    "\ ['darkred',     'SeaGreen3'],
    "\ ['darkmagenta', 'DarkOrchid3'],
    "\ ['brown',       'firebrick3'],
    "\ ['gray',        'RoyalBlue3'],
    "\ ['black',       'SeaGreen3'],
    "\ ['darkmagenta', 'DarkOrchid3'],
    "\ ['Darkblue',    'firebrick3'],
    "\ ['darkgreen',   'RoyalBlue3'],
    "\ ['darkcyan',    'SeaGreen3'],
    "\ ['darkred',     'DarkOrchid3'],
    "\ ['red',         'firebrick3'],
    "\ ]

"let g:rbpt_max = 16

"" Always on
"au VimEnter * RainbowParenthesesToggle
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces
