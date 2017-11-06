call plug#begin()
" Plug 'neomake/neomake', { 'on': 'Neomake' }
Plug 'dikiaap/minimalist'
Plug 'scrooloose/nerdtree'
Plug 'Nopik/vim-nerdtree-direnter'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tomtom/tcomment_vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ludovicchabant/vim-gutentags'
Plug 'Yggdroot/indentLine'
Plug 'dbakker/vim-projectroot'

"Javascript Plugins
Plug 'sheerun/vim-polyglot'
" Plug 'carlitux/deoplete-ternjs'
" Plug 'ternjs/tern_for_vim', { 'do': 'yarn install; and yarn global add tern' }
Plug 'w0rp/ale'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'

" Load Last
Plug 'ryanoasis/vim-devicons'
call plug#end()

let g:airline#extensions#tabline#enabled = 1

let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'json': ['prettier'],
\}
let g:ale_fix_on_save = 1

set runtimepath+=expand("$XDG_CONFIG_HOME/nvim/plugged/deoplete.nvim")
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#enable_refresh_always = 1
let g:deoplete#max_abbr_width = 0
let g:deoplete#max_menu_width = 0
let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
" call deoplete#custom#set('_', 'matchers', ['matcher_full_fuzzy'])

" let g:tern_request_timeout = 1
" let g:tern_request_timeout = 6000
" let g:tern#command = ["tern"]
" let g:tern#arguments = ["--persistent"]
let g:deoplete#sources#tss#javascript_support = 1

let g:indentLine_enabled = 1
let g:indentLine_char = '¦'

set ignorecase          " Make searching case insensitive
set smartcase           " ... unless the query has capital letters.
set gdefault            " Use 'g' flag by default with :s/foo/bar/.
set magic               " Use 'magic' patterns (extended regular expressions).

let mapleader=","
let g:mapleader=","

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

nmap <Leader>s :%s//g<Left><Left>

nmap <Leader>t :Files<CR>
nmap <Leader>r :BTags<CR>
nmap <Leader>/ :TComment<CR>

set showmatch           " Show matching brackets.
set number              " Show the line numbers on the left side.
set formatoptions+=o    " Continue comment marker in new lines.
set textwidth=0         " Hard-wrap long lines as you type them.
set expandtab           " Insert spaces when TAB is pressed.
set tabstop=2           " Render TABs using this many spaces.
set shiftwidth=2        " Indentation amount for < and > commands.

set linespace=0         " Set line-spacing to minimum.
set nojoinspaces        " Prevents inserting two spaces after punctuation on a join (J)

" More natural splits
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.

if !&scrolloff
set scrolloff=3       " Show next 3 lines while scrolling.
endif
if !&sidescrolloff
set sidescrolloff=5   " Show next 5 columns while side-scrolling.
endif
set nostartofline       " Do not jump to first character with page commands.

let g:netrw_banner = 0
let g:netrw_browse_split = 3
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_winsize = 30
let g:gutentags_generate_on_new = 1
let g:gutentags_project_root_finder = 'ProjectRootGuess'
let g:gutentags_ctags_tagfile = '.tags'
set tags=./.tags;./tags
set tags=./.tags;./tags

set encoding=utf8
set nocompatible
set t_Co=256
set termguicolors
set guifont=FuraCode\ Nerd\ Font\ 18

colorscheme minimalist

let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=0
let NERDTreeMapOpenInTab='<ENTER>'
nmap <Leader>e :NERDTreeToggle<CR>
nmap <Leader>E :NERDTreeFind<CR>

set history=100
set synmaxcol=1000
set autowrite
set nobackup
set nowritebackup
set noswapfile
set ttyfast
set shortmess+=A                 " ignore annoying swapfile messages
set shortmess+=I                 " no splash screen
set shortmess+=O                 " file-read message overwrites previous
set shortmess+=T                 " truncate non-file messages in middle
set shortmess+=W                 " don't echo "[w]"/"[written]" when writing
set shortmess+=a                 " use abbreviations in messages eg. `[RO]` instead of `[readonly]`
set shortmess+=o                 " overwrite file-written messages
set shortmess+=t                 " truncate file messages at start
set report=0                     " tell us when anything is changed via :...
set inccommand=split             " incremental command live feedback
" end pdev custom
