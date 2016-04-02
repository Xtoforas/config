""""""""""
"From S.Doherty's VIMRC
""""""""""
"set title - THANKS FOR FLYING VIM
if v:version >= 700
  execute pathogen#infect()
  autocmd vimenter * NERDTree
  autocmd bufenter * NERDTreeMirror
  autocmd vimenter * wincmd w
endif

set exrc
set secure
set ruler
set showcmd
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

if v:progname =~? "evim"
    finish
endif

set nocompatible

if has("vms")
    set nobackup
else
    set backup
endif

set backupdir=~/.backup

" If terminal can display syntax, turn it on
if has('syntax') && (&t_Co > 2)
    syntax on
endif

if has("autocmd")
    "Enable file type detection
    "Use the default filetype settings, so that mail gets 'tw' set to 72
    "cindent is on in C files
    "Also load indent files, to automatically do language-dependent indenting
    filetype plugin on

    "For all text files, set width to 300 characters
    autocmd FileType text setlocal textwidth=300
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     exe "normal g'\"" |
        \ endif
endif

set history=50
" remember all of these between sessions, but only 10 search terms; also
" remember info for 10 files, but never any on removable disks, don't remember
" marks in files, don't rehighlight old search patterns, and only save up to
" 100 lines of registers; including @10 in there should restrict input buffer
" but it causes an error for me:
set viminfo=/10,'10,r/mnt/zip,r/mnt/floppy,f0,h,\"100

" have command-line completion <Tab> (for filenames, help topics, option names)
" first list the available options and complete the longest common part, then
" have further <Tab>s cycle through the possibilities:
set wildmode=list:longest,full

" use "[RO]" for "[readonly]" to save space in the message line:
set shortmess+=r

" display the current mode and partially-typed commands in the status line:
set showmode
set showcmd
" use indents of 2 spaces, and have them copied down lines:
set shiftwidth=2 tabstop=2 softtabstop=2
set shiftround
set expandtab
set autoindent

" normally don't automatically format `text' as it is typed, IE only do this
" with comments, at 79 characters:
set formatoptions-=t
set textwidth=300

" get rid of the default style of C comments, and define a style with two stars
" at the start of `middle' rows which (looks nicer and) avoids asterisks used
" for bullet lists being treated like C comments; then define a bullet list
" style for single stars (like already is for hyphens):
set comments-=s1:/*,mb:*,ex:*/
set comments+=s:/*,mb:**,ex:*/
set comments+=fb:*

" for C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang set cindent

" for actual C (not C++) programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c set formatoptions+=ro

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8
autocmd FileType python set expandtab shiftwidth=4 tabstop=4

" show the `best match so far' as search strings are typed:
set incsearch

" Searches are NOT case sensitive
set ignorecase

" have <F1> prompt for a help topic, rather than displaying the introduction
" page, and have it do this from any mode:
nnoremap <F1> :help<Space>
vmap <F1> <C-C><F1>
omap <F1> <C-C><F1>
map! <F1> <C-C><F1>

" allow <BkSpc> to delete line breaks, beyond the start of the current
" insertion, and over indentations:
set backspace=eol,start,indent

" map control-backspace to delete the previous word
imap <C-BS>        <Esc>vBc


fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map f :call ShowFuncName() <CR>

function! ShowFunc()

    let gf_s = &grepformat
    let gp_s = &grepprg

    let &grepformat = '%*\k%*\sfunction%*\s%l%*\s%f %*\s%m'
    let &grepprg = 'ctags -x --c-types=f --sort=no -o -'

    write
    silent! grep %
    cwindow

    let &grepformat = gf_s
    let &grepprg = gp_s

endfunc

""""""""""
"Settings"
""""""""""
set number
filetype on
set showmode
set laststatus=2 ruler
set listchars=trail:~,tab:>.
set showmatch matchpairs+=<:>
set path+=/vobs/**
set nowrap

syntax enable
if has('gui_running')
  set background=dark
else
  set background=light
endif
if v:version >= 700
  let g:solarized_termcolors=256
  colorscheme solarized
else
  colorscheme murphy
endif

"window positioning"
set wmw=0
set wmh=0
"winpos 1685 25
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l
nmap <c-h> <c-w>h

"indentation"
set autoindent
autocmd BufLeave * set expandtab shiftwidth=2 softtabstop=2
autocmd BufEnter Makefile* set noexpandtab shiftwidth=8 softtabstop=8
doautocmd BufLeave

"searching"
set backspace=2
set complete+=,]
set history=100
set nrformats+=alpha
"set tags=./tags,./../tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags,./../../../../../../tags,/vobs/cware/tags
set tags=./tags,tags
set winaltkeys=no

set guifont=Consolas\ 10

"folding options"
"syn region myFold start="{" end="}" transparent fold
"syn sync fromstart
"set foldmethod=indent
"au BufWinLeave * mkview
"au BufWinEnter * silent loadview

"spell checking"
abbreviate teh the
abbreviate thsid thisd

"Mappings"
""""""""""
"map F1 to escape for the sake of my sanity"
map  <F1> <Esc>
imap <F1> <Esc>

"quit all"
map ZA :qa<CR>

"better pageup/pagedown"
map    <PageUp> <C-U>
imap   <PageUp> <Esc><C-U>i
map  <PageDown> <C-D>
imap <PageDown> <Esc><C-D>i

"cycle through buffers"
map         <Tab> :bnext<CR>
map       <S-Tab> :bprev<CR>
map <Leader><Tab> :bprev<CR>

"function commands"
map <F2> :Explore<CR>
map <F3> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
map <F4> :make clean<CR>
map <F5> :w<CR>:make -j<CR>
noremap <F6> :buffers<CR>:buffer<Space>
map <F11> :let &background = ( &background == "dark"? "light" : "dark" )<CR>

"leader commands"
map  <Leader>1 :set   expandtab shiftwidth=1 softtabstop=1<CR>
map  <Leader>2 :set   expandtab shiftwidth=2 softtabstop=2<CR>
map  <Leader>4 :set   expandtab shiftwidth=4 softtabstop=4<CR>
map  <Leader>8 :set noexpandtab shiftwidth=8 softtabstop=8<CR>
vmap <Leader>c !fmt --prefix=// --width=60<CR>
map  <Leader>d <Leader>"d
map  <Leader>D <Leader>"D
map  <Leader>e :cn<CR>
map  <Leader>E :cp<CR>
map  <Leader>f mz{V}!fmt -w70<CR>'z
vmap <Leader>f !fmt -w70<CR>
map  <Leader>p <Leader>"p
map  <Leader>P <Leader>"P
map  <Leader>r :syntax off<CR>:syntax on<CR>
vmap <Leader>s !sort<CR>
map  <Leader>S :set invspell<CR>
map  <Leader>w /\s\+$<CR>
map  <Leader>W :%s/\s\+$//<CR>
map  <Leader>y <Leader>"y
map  <Leader>Y <Leader>"Y
map  <Leader>" "*
"map  <Leader>/ :let @/ = ""<CR>
map  <Leader>/ :nohlsearch<CR>
nnoremap <F12> :TlistToggle<CR>


if v:version >= 700
  map <C-n> :NERDTreeToggle<CR>
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*

  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
  let g:syntastic_c_include_dirs = [ '/lsi/home/colekas/src/r12cpu/cpu_mctf/include', '/lsi/home/colekas/src/r12cpu/cpu_h264dec/include', '/lsi/home/colekas/src/r12cpu/cpu_mpeg2dec/include', '/lsi/home/colekas/src/r12cpu/cpu_enc/lib', '/lsi/home/colekas/src/r12cpu/cpu_enc/include', '/lsi/home/colekas/src/r12cpu/cpu_common/lib', '/lsi/home/colekas/src/r12cpu/cpu_common/include', '/lsi/home/colekas/src/r12cpu/cpu_utils/include', '/lsi/home/colekas/src/r12cpu/cpu_integ/include' ]
  let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
  nnoremap <C-w>E :SyntasticCheck<CR> :SyntasticToggleMode<CR>
endif

" bind K to grep word under cursor
"nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap K :grep! -rn "<C-R><C-W>" include/ d7_h264enc_dispatch/frm_lib/ d7_h264enc_dispatch/frm_app/ d7_h264enc_dispatch/include/ d7_mpg2enc_dispatch/frm_lib/ d7_mpg2enc_dispatch/frm_app/ d7_mpg2enc_dispatch/include/ d7_hevc_enc/frm_lib/ d7_hevc_enc/frm_app/ d7_hevc_enc/include/<CR>:cw<CR>
nnoremap L :grep! -rn "<C-R><C-W>" * --exclude-dir obj/ --exclude-dir build/<CR>:cw<CR>
"let Tlist_Ctags_Cmd='/lsi/home/colekas/bin/ctags'


"Taken from ffmpeg fromatting conventions
" indentation rules for FFmpeg: 4 spaces, no tabs
set expandtab
"set shiftwidth=4
"set softtabstop=4
set cindent
set cinoptions=(0
" Allow tabs in Makefiles.
autocmd FileType make,automake set noexpandtab shiftwidth=8 softtabstop=8
" Trailing whitespace and tabs are forbidden, so highlight them.
highlight ForbiddenWhitespace ctermbg=red guibg=red
match ForbiddenWhitespace /\s\+$\|\t/
" Do not highlight spaces at the end of line while typing on that line.
autocmd InsertEnter * match ForbiddenWhitespace /\t\|\s\+\%#\@<!$/


