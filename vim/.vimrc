" ~/.vimrc -- Vim 9 port of the kickstart-based nvim config in IbrahimElk/dotfiles
" Requires: vim 9+, git, curl, ripgrep, fzf. For clipboard on Wayland see the
" CLIPBOARD section. Install plugins with :PlugInstall

set nocompatible
set t_RB= t_RF= t_RV= t_u7= t_RC= t_RS=
set t_fe= t_fd=
let mapleader = " "
let maplocalleader = " "

" ---------------------------------------------------------------- plugins ---
let s:plug = expand('~/.vim/autoload/plug.vim')
if empty(glob(s:plug))
  silent execute '!curl -fLo ' . s:plug . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sleuth'                       " same as nvim
Plug 'mhinz/vim-startify'                     " same as nvim
Plug 'lervag/vimtex'                          " same as nvim
Plug 'goerz/jupytext.vim'                     " jupytext.nvim (needs `jupytext` CLI)
Plug 'rust-lang/rust.vim'                     " rustaceanvim (syntax/fmt only)
Plug 'ghifarit53/tokyonight-vim'              " tokyonight.nvim
Plug 'itchyny/lightline.vim'                  " mini.statusline
Plug 'wellle/targets.vim'                     " mini.ai
Plug 'machakann/vim-sandwich'                 " mini.surround (same sa/sd/sr keys)
Plug 'machakann/vim-highlightedyank'          " vim.highlight.on_yank
Plug 'jiangmiao/auto-pairs'                   " nvim-autopairs
Plug 'nathanaelkane/vim-indent-guides'        " indent-blankline
Plug 'tpope/vim-vinegar'                      " oil.nvim (browsing only, `-` key)
Plug 'liuchengxu/vim-which-key'               " which-key.nvim
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                       " telescope.nvim
Plug 'airblade/vim-gitgutter'                 " gitsigns.nvim
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'                " blame popup for the current line
Plug 'dense-analysis/ale'                     " nvim-lint (lint only, LSP off)
Plug 'prabirshrestha/vim-lsp'                 " nvim-lspconfig
Plug 'mattn/vim-lsp-settings'                 " mason (:LspInstallServer)
Plug 'prabirshrestha/asyncomplete.vim'        " nvim-cmp
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'   " cmp-path
Plug 'hrsh7th/vim-vsnip'                      " LuaSnip
Plug 'hrsh7th/vim-vsnip-integ'
call plug#end()

" ----------------------------------------------------------------- options ---
set number relativenumber
set mouse=
set noshowmode
set breakindent
set undofile
set ignorecase smartcase
set signcolumn=yes
set updatetime=250
set timeout timeoutlen=300 ttimeout ttimeoutlen=50
set splitright splitbelow
set nolist listchars=trail:·,nbsp:␣
set cursorline
set scrolloff=10
set spelllang=en_gb,nl,fr nospell
set hlsearch incsearch
set completeopt=menuone,noinsert,noselect
" no equivalent in Vim: inccommand=split (live :s preview)

let s:undodir = expand('~/.vim/undo')
if !isdirectory(s:undodir) | call mkdir(s:undodir, 'p', 0700) | endif
let &undodir = s:undodir . '//'

if &term =~# '^\(tmux\|screen\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set termguicolors

" --------------------------------------------------------------- clipboard ---
" Yank -> system clipboard via OSC 52. Works locally and over ssh/tmux as long
" as the terminal emulator supports OSC 52 (kitty, foot, alacritty, wezterm, ...).

function! s:osc52_copy(text) abort
  let l:b64 = substitute(system('base64', a:text), '\n', '', 'g')
  let l:seq = "\e]52;c;" . l:b64 . "\x07"
  if exists('*echoraw')
    call echoraw(l:seq)
  else
    call writefile([l:seq], '/dev/tty', 'b')
  endif
endfunction

if has('clipboard')
  set clipboard=unnamedplus
else
  augroup user_osc52
    autocmd!
    autocmd TextYankPost *
          \ call s:osc52_copy(join(v:event.regcontents, "\n")
          \     . (v:event.regtype ==# 'V' ? "\n" : ''))
  augroup END
endif

" ------------------------------------------------------------- colorscheme ---
let g:tokyonight_style = 'night'
let g:tokyonight_disable_italic_comment = 1
colorscheme tokyonight
highlight Comment gui=NONE cterm=NONE
let g:lightline = { 'colorscheme': 'tokyonight',
      \ 'component': { 'lineinfo': '%2l:%-2v' } }
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1

" ----------------------------------------------------------------- keymaps ---
nnoremap <silent> <Esc> :nohlsearch<CR>
nnoremap <leader>t :vertical terminal<CR>

nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>

" `-` opens the parent directory: provided by vim-vinegar (netrw).

" -------------------------------------------------------------- autocmds ---
augroup user_ft
  autocmd!
  autocmd FileType cpp    setlocal commentstring=//\ %s
  autocmd FileType racket setlocal commentstring=;;\ %s
augroup END

" TODO(name) / FIXME(name) highlighting, like todo-comments.nvim's custom pattern
augroup user_todo
  autocmd!
  autocmd Syntax * syntax match UserTodo /\v<(TODO|FIXME|NOTE|HACK|WARN|PERF|BUG)\s*\(.*\)/ containedin=.*Comment,.*String
  highlight default link UserTodo Todo
augroup END

" ---------------------------------------------------------- fzf (telescope) ---
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden -g "!.git"'

function! RipgrepFzf(query, fullscreen) abort
  let l:cmd = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let l:spec = {'options': ['--phony', '--query', a:query, '--bind',
        \ 'change:reload:' . printf(l:cmd, '{q}')]}
  call fzf#vim#grep(printf(l:cmd, shellescape(a:query)), 1, fzf#vim#with_preview(l:spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

nnoremap <leader>sh :Helptags<CR>
nnoremap <leader>sk :Maps<CR>
nnoremap <leader>sf :Files<CR>
nnoremap <leader>ss :Commands<CR>
nnoremap <leader>sw :Rg <C-r><C-w><CR>
nnoremap <leader>sg :RG<CR>
nnoremap <leader>sd :LspDocumentDiagnostics<CR>
nnoremap <leader>s. :History<CR>
nnoremap <leader><leader> :Buffers<CR>
nnoremap <leader>/ :BLines<CR>
nnoremap <leader>s/ :Lines<CR>
nnoremap <leader>sn :Files ~/.vim<CR>
" no fzf.vim equivalent of <leader>sr (telescope resume)

" which-key
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" ------------------------------------------------------ git (gitsigns) ---
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '_'
let g:gitgutter_sign_removed_first_line = '‾'
let g:gitgutter_sign_modified_removed = '~'
let g:gitgutter_map_keys = 0          " use our own maps; ]c and [c below

nmap ]c <Plug>(GitGutterNextHunk)
nmap [c <Plug>(GitGutterPrevHunk)
nmap <leader>hs <Plug>(GitGutterStageHunk)
xmap <leader>hs <Plug>(GitGutterStageHunk)
nmap <leader>hr <Plug>(GitGutterUndoHunk)
nmap <leader>hp <Plug>(GitGutterPreviewHunk)
nnoremap <leader>hb :GitMessenger<CR>
nnoremap <leader>hd :Gdiffsplit<CR>
nnoremap <leader>hD :Gdiffsplit HEAD<CR>
nnoremap <leader>hS :Git add %<CR>
" not ported: hR (reset buffer), hu (undo stage), always-on inline blame, toggle deleted

" ------------------------------------------------------- LSP (lspconfig) ---
let g:lsp_diagnostics_enabled = 1
let g:lsp_document_highlight_enabled = 1
let g:lsp_settings = {
      \ 'clangd': { 'cmd': ['clangd', '--background-index', '--clang-tidy'] },
      \ }
" Servers: :LspInstallServer inside a file installs clangd, pyright, deno,
" haskell-language-server, lua-language-server, rust-analyzer via vim-lsp-settings.

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  nmap <buffer> gd         <plug>(lsp-definition)
  nmap <buffer> gr         <plug>(lsp-references)
  nmap <buffer> gI         <plug>(lsp-implementation)
  nmap <buffer> gD         <plug>(lsp-declaration)
  nmap <buffer> K          <plug>(lsp-hover)
  nmap <buffer> <leader>D  <plug>(lsp-type-definition)
  nmap <buffer> <leader>ds <plug>(lsp-document-symbol-search)
  nmap <buffer> <leader>ws <plug>(lsp-workspace-symbol-search)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> <leader>ca <plug>(lsp-code-action)
  xmap <buffer> <leader>ca <plug>(lsp-code-action)
  nmap <buffer> <leader>f  <plug>(lsp-document-format)
  xmap <buffer> <leader>f  <plug>(lsp-document-format)
endfunction

augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" format on save via LSP, except C/C++ (conform.nvim config)
augroup lsp_format
  autocmd!
  autocmd BufWritePre * if index(['c', 'cpp'], &filetype) < 0 | silent! LspDocumentFormatSync | endif
augroup END

" diagnostics
nnoremap <leader>q :LspDocumentDiagnostics<CR>
let b:diag_on = 1
function! s:toggle_diagnostics() abort
  if get(b:, 'diag_on', 1)
    call lsp#disable_diagnostics_for_buffer() | let b:diag_on = 0
  else
    call lsp#enable_diagnostics_for_buffer()  | let b:diag_on = 1
  endif
endfunction
nnoremap <leader>ud :call <SID>toggle_diagnostics()<CR>

" trouble.nvim -> quickfix / location list
nnoremap <leader>xx :LspDocumentDiagnostics<CR>
nnoremap <leader>xL :lopen<CR>
nnoremap <leader>xQ :copen<CR>

" ------------------------------------------------------ lint (nvim-lint) ---
let g:ale_disable_lsp = 1
let g:ale_linters_explicit = 1
let g:ale_linters = { 'markdown': ['markdownlint'], 'cpp': ['cpplint'], 'haskell': ['hlint'] }
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_fix_on_save = 0

" ------------------------------------------------- completion (nvim-cmp) ---
let g:AutoPairsMapCR = 0              " we map <CR> ourselves below

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" confirm; if nothing is selected pick the first item (cmp confirm{select=true})
inoremap <expr> <CR> pumvisible()
      \ ? (complete_info().selected == -1 ? "\<C-n>\<C-y>" : "\<C-y>")
      \ : "\<C-g>u\<CR>" . AutoPairsReturn()
inoremap <expr> <C-Space> asyncomplete#force_refresh()
inoremap <expr> <C-@>     asyncomplete#force_refresh()

" snippet jumps (C-l / C-h)
imap <expr> <C-l> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-l>'
smap <expr> <C-l> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-l>'
imap <expr> <C-h> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-h>'
smap <expr> <C-h> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-h>'

augroup asyncomplete_sources
  autocmd!
  autocmd User asyncomplete_setup call asyncomplete#register_source(
        \ asyncomplete#sources#file#get_source_options({
        \   'name': 'file', 'allowlist': ['*'], 'priority': 10,
        \   'completor': function('asyncomplete#sources#file#completor')}))
augroup END

" ----------------------------------------------------- misc plugin config ---
" startify (same as nvim)
let g:startify_change_to_dir = 0
let g:startify_lists = [ { 'type': 'dir', 'header': ['   Recent in ' . getcwd()] } ]

" vimtex (same as nvim)
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_mode = 0
set conceallevel=1
let g:tex_conceal = 'abdmg'
let g:vimtex_compiler_latexmk = { 'out_dir': 'build' }
