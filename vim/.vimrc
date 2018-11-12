if has('python3')
  silent! python3 1
endif
set nocompatible
call pathogen#helptags()
call pathogen#infect()
let mapleader="," " map leader changed to comma
set noruler       " hide the position of cursor in the buffer
set laststatus=0  " hide the statusline
nmap <silent> \ev :e $MYVIMRC<CR>
nmap <silent> \sv :so $MYVIMRC<CR>
nmap <F8> :TagbarToggle<CR>
autocmd FileType python setlocal completeopt-=preview
filetype plugin on

set encoding=utf-8
set hidden
set nowrap          " don't wrap lines

set tabstop=4       " a tab is four spaces
set shiftwidth=4    " number of spaces to use for autoindenting
set expandtab       " convert tab to spaces
set breakindent     " wrap at indents
set autoindent      " always set autoindenting on
set smartindent     " smartly indent a/c to syntax
inoremap # X#
set copyindent      " copy the previous indentation on autoindenting
set fileformat=unix " set unix file format
set splitbelow      " split new windows below current
set splitright      " split new windows to the right of current

" PEP8 for python
au BufNewFile,BufRead *.py
  \ set tabstop=4 |
  \ set softtabstop=4 |
  \ set shiftwidth=4 |
  " \ set textwidth=79 |
  \ set expandtab |
  \ set autoindent |
  \ set fileformat=unix |
" for others
au BufNewFile,BufRead *.php,*.js,*.ts,*.html,*.css,*.scss,*.md,*.json,*.vimrc
  \ set tabstop=2 |
  \ set softtabstop=2 |
  \ set shiftwidth=2 |
au BufNewFile,BufRead *.ts
  \ set filetype=javascript |
" UK English spell check for tex files
au FileType tex
  \ setlocal spell spelllang=en_gb

" command and function for changing indentation level for tabs
function SetIndent(indent)
  let &shiftwidth=a:indent
  execute ":IndentLinesDisable"
  execute ":IndentLinesEnable"
endfunction
command -nargs=1 SetIndent call SetIndent(<f-args>)

" remove extra whitespace
highlight BadWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" delete without yanking
" nnoremap <leader>D "_d
" vnoremap <leader>D "_d

set backspace=indent,eol,start         " allow backspacing over everything in insert mode
set number relativenumber              " always show line numbers
set shiftround                         " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch                          " set show matching parenthesis
set ignorecase                         " ignore case when searching
set smartcase                          " ignore case if search pattern is all lowercase, case-sensitive otherwise
set smarttab                           " insert tabs on the start of a line according to shiftwidth, not tabstop
set hlsearch                           " highlight search terms
set incsearch                          " show search matches as you type
set history=1000                       " remember more commands and search history
set undolevels=1000                    " use many muchos levels of undo
set visualbell                         " don't beep
set noerrorbells                       " don't beep
set nrformats=alpha                    " create letter sequences
set undofile                           " Maintain undo history between sessions
set undodir=/home/rharish/.vim/undodir " Undo save directory
set updatetime=1000                    " Swap update time
let g:instant_markdown_autostart = 0   " Don't start instant markdown preview on start
let g:NERDSpaceDelims = 1              " Delimit comments by one space
command BufDelete bp | bd #            " Delete buffer
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

" Close NERDTree on closing all buffers
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:ale_fixers={'python': ['black']}                          " Use black for fixing linting issues
call ale#Set('python_black_options', '--fast --line-length=79') " Use black with line length limit of 79
let g:ale_fix_on_save=1                                         " Fix files on save
let g:ale_pattern_options = {'.*\.tex$': {'ale_enabled': 0}}    " Disable ALE for tex files
nmap <leader>f :ALEFix<CR>

let g:strip_whitespace_on_save=1                   " strip trailing whitespace on save
let g:livepreview_engine = 'xelatex -shell-escape' " default pdf engine for latex-preview
let g:ycm_seed_identifiers_with_syntax = 1         " ycm suggests built-ins

" noremap <silent> <C-U> :call smooth_scroll#up(&scroll, 30, 2)<CR>
" noremap <silent> <C-D> :call smooth_scroll#down(&scroll, 30, 2)<CR>
" noremap <silent> <C-B> :call smooth_scroll#up(&scroll*2, 30, 4)<CR>
" noremap <silent> <C-F> :call smooth_scroll#down(&scroll*2, 30, 4)<CR>

let g:indentLine_showFirstIndentLevel = 1                      " show first indent level
let g:indentLine_first_char = '▏'                              " character for indent lines
let g:indentLine_char = '▏'                                    " character for indent lines
let g:indentLine_color_term = 8                                " do not change gray color
let g:indentLine_color_gui = '#505666'                         " do not change gray color
let g:indentLine_bufTypeExclude = ['tex', 'json', 'markdown']  " exclude tex and json files
let g:indentLine_fileTypeExclude = ['tex', 'json', 'markdown'] " exclude tex and json files

set foldmethod=indent    " allow folding of code
:nmap <leader>s :set foldmethod=indent<CR>
set foldlevel=99
nnoremap <space> za

"let g:SimpylFold_docstring_preview=1                  " docstring preview when folded
let g:fastfold_fold_command_suffixes = []             " fastfold
let g:ycm_autoclose_preview_window_after_completion=1 " close preview
" remember folds
augroup AutoSaveFolds
  autocmd!
  autocmd BufWinLeave ?* mkview
  autocmd BufWinEnter ?* silent loadview
  autocmd BufWinEnter ?* set foldmethod=indent
augroup END

" python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

" shebang defs
let g:shebang#shebangs = {
  \ 'awk': '#!/usr/bin/awk -f',
  \ 'php': '',
  \ 'sh' : '#!/usr/bin/zsh',
  \ }

if &t_Co >= 256 || has("gui_running")
  colorscheme arcdark
endif
if &t_Co > 2 || has("gui_running")
  " switch syntax highlighting on, when the terminal has colors
  syntax on
endif

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" Change case with ~ key
function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
      let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
      let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
      let result = toupper(a:str)
  endif
  return result
endfunction
vnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv

" Mappings for clipboard functionality
autocmd VimLeave * call system('echo ' . shellescape(getreg('+')) . ' | xclip -selection clipboard')    " Do not erase clipboard
" normal mode
:nmap <leader>y "+y
:nmap <leader>Y "+yy
:nmap <leader>p o<space><ESC>v"+p
:nmap <leader><S-p> <S-o><space><ESC>v"+p
:nmap <leader>d "+d
" visual mode
:vmap <leader>y "+y
:vmap <leader>Y "+yy
:vmap <leader>p "+p
:vmap <leader><S-p> <S-o><space><ESC>v"+p
:vmap <leader>d "+d
