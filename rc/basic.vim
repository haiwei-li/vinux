" basic package
" Package info {{{
if  g:file_explorer_plugin.cur_val == 'defx.nvim'
    if te#env#IsNvim() == 0 && te#env#IsVim() < 802
        call te#utils#EchoWarning("defx requires Neovim 0.4.0+ or Vim8.2+ with Python3.6.1+")
        let g:file_explorer_plugin.cur_val = 'nerdtree'
    else
        Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins'}
        let s:defx_option=':Defx -toggle -split=vertical -winwidth=50 -direction=topleft '
        if g:enable_powerline_fonts.cur_val == 'on'
            Plug 'kristijanhusak/defx-icons'
            let s:defx_option.=' -columns=git:icons:indent:filename:type '
        endif
        " Open nerd tree
        if te#env#SupportFloatingWindows() == 2
            let s:defx_option.=' -floating-preview '
        endif
        execute 'nnoremap  <silent><leader>te '.s:defx_option.'<cr>'
        execute 'nnoremap  <silent><F12> '.s:defx_option.'<cr>'
        " Open nerd tree
        nnoremap  <silent><leader>nf :Defx -toggle -split=vertical -winwidth=50 -direction=topleft `expand('%:p:h')` -search=`expand('%:p')`<CR> 
        call te#tools#register_sexy_command(s:defx_option)
    endif
elseif g:file_explorer_plugin.cur_val == 'fern.vim'
    if te#env#IsNvim() < 0.8 && te#env#IsVim() < 802
        call te#utils#EchoWarning("fern.vim requires Neovim 0.8+ or Vim8.0+")
        let g:file_explorer_plugin.cur_val = 'nerdtree'
    else
        call te#feat#source_rc('fern.vim')
    endif
endif

if g:file_explorer_plugin.cur_val == 'nvim-tree.lua'
    if te#env#IsNvim() == 0
        call te#utils#EchoWarning("nvim-tree.lua requires Neovim 0.9.0+")
        let g:file_explorer_plugin.cur_val = 'nerdtree'
    else
        Plug 'nvim-tree/nvim-tree.lua'
function! s:nvim_tree_setup()
lua << EOF
require("nvim_tree")
EOF
endfunction
nnoremap <silent><leader>te :NvimTreeToggle .<cr>
nnoremap <silent><F12> :NvimTreeToggle .<cr>
nnoremap <silent><leader>nf :NvimTreeFindFile<cr>
call te#feat#register_vim_enter_setting(function('<SID>nvim_tree_setup'))
    endif
endif

if g:file_explorer_plugin.cur_val == 'nerdtree'
    Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle','NERDTreeFind'] }
    call te#tools#register_sexy_command('NERDTreeToggle')
    let g:NERDTreeShowLineNumbers=0	"don't show line number
    let g:NERDTreeWinPos='left'	"show nerdtree in the rigth side
    "let NERDTreeWinSize='30'
    let g:NERDTreeShowBookmarks=1
    let g:NERDTreeChDirMode=2
    noremap <F12> :NERDTreeToggle .<CR> 
    " Open nerd tree
    nnoremap  <silent><leader>te :NERDTreeToggle .<CR> 
    " Open nerd tree
    nnoremap  <silent><leader>nf :NERDTreeFind<CR> 
    "map <2-LeftMouse>  *N "double click highlight the current cursor word 
    inoremap <F12> <ESC> :NERDTreeToggle<CR>
endif

if te#env#IsNvim() >= 0.5
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
    Plug 'nvim-treesitter/nvim-treesitter-refactor'
    Plug 'nvim-treesitter/nvim-treesitter-context'
    function! s:treesitter_setup()
lua << EOF
            require('treesittier_nvim')
EOF
    endfunction
    call te#feat#register_vim_enter_setting(function('<SID>treesitter_setup'))
endif

if te#env#check_requirement()
    Plug 'majutsushi/tagbar',{'on': []}
    " Open tagbar
    nnoremap <silent><F9> :TagbarToggle<CR>
    nnoremap  <silent><leader>tt :TagbarToggle<CR>
    call te#tools#register_sexy_command('TagbarOpen')
    let g:tagbar_left=0
    let g:tagbar_width=30
    let g:tagbar_sort=0
    let g:tagbar_autofocus = 1
    let g:tagbar_compact = 1
    let g:tagbar_systemenc='cp936'
    let g:tagbar_iconchars = ['+', '-']
    call te#feat#register_vim_enter_setting2([0], ['tagbar'])
else
    Plug 'tracyone/vim-taglist'
    nnoremap <silent><F9> :TlistToggle<CR>
    nnoremap  <silent><leader>tt :TlistToggle<CR>
    call te#tools#register_sexy_command(':TlistToggle')
    let Tlist_Show_One_File = 1
    let Tlist_Use_Right_Window = 1
    let Tlist_GainFocus_On_ToggleOpen=1
endif

"vimproc required by vim-clang-format and quickrun
if te#env#IsMac()
    Plug 'Shougo/vimproc.vim', { 'do': 'make -f make_mac.mak' }
elseif te#env#IsUnix()
    Plug 'Shougo/vimproc.vim', { 'do': 'make' }
else
    Plug 'Shougo/vimproc.vim'
endif
if !te#env#SupportTerminal() && !te#env#IsTmux()
    Plug 'Shougo/vimshell.vim',{'on':'VimShell'}
    Plug 'tracyone/ctrlp-vimshell.vim',{'on':'VimShell'}
endif
Plug 'tracyone/love.vim'
Plug 'tracyone/mark.vim',{'on':[]}
Plug 'itchyny/vim-cursorword', {'on':[]}
call te#feat#register_vim_enter_setting2([0],['mark.vim', 'vim-cursorword'])
Plug 'thinca/vim-quickrun',{'on': '<Plug>(quickrun)'}
if(!te#env#IsWindows())
    Plug 'vim-scripts/sudo.vim', {'on': ['SudoRead', 'SudoWrite']}
    if te#env#IsVim() >= 900
        runtime ftplugin/man.vim
    else
        if te#env#IsNvim() == 0
            Plug 'lambdalisue/vim-manpager'
        endif
    endif
    if te#env#IsMac()
        Plug 'CodeFalling/fcitx-vim-osx',{'do': 'wget -c \"https://raw.githubusercontent.com/
                    \CodeFalling/fcitx-remote-for-osx/binary/fcitx-remote-sogou-pinyin\" && 
                    \chmod a+x fcitx* && mv fcitx* /usr/local/bin/fcitx-remote','on': [] }
    else
        Plug 'CodeFalling/fcitx-vim-osx', { 'on': [] }
    endif

    call te#feat#register_vim_plug_insert_setting([], 
                \ ['fcitx-vim-osx'])
endif
if te#env#IsVim8() || te#env#IsNvim() != 0
    Plug 'neomake/neomake', { 'commit': '443dcc03b79b2402bd14600c9c4377266f07d1f4', 'on': []}
    Plug 'tracyone/neomake-multiprocess', {'on': []}
    "ag search c family function
    nnoremap  <silent><leader>vf :call neomakemp#global_search(expand("<cword>") . "\\s*\\([^()]*\\)\\s*[^;]")<cr>
    nnoremap  <silent><leader>nm :call te#tools#get_enabler_linter()<cr>
    function! Neomake_setting()
        if get(g:, 'feat_enable_lsp') == 0
            silent! call neomake#configure#automake('nrwi', 500)
        endif
        "disable linter of specified filetype by setting
        "g:neomake_ft_enabled_makers=[]
        "let g:neomake_vim_enabled_makers = []
        "let g:neomake_c_enabled_makers = []
        nnoremap  <silent><Leader>nn :Neomake<cr>
        "let g:neomake_open_list=2
        let g:neomake_info_sign = {'text': g:vinux_diagnostics_signs_info, 'texthl': 'NeomakeInfoSign'}
        let g:neomake_warning_sign = {
                    \ 'text': g:vinux_diagnostics_signs_warning,
                    \ 'texthl': 'WarningMsg',
                    \ }
        let g:neomake_error_sign = {
                    \ 'text': g:vinux_diagnostics_signs_error,
                    \ 'texthl': 'ErrorMsg',
                    \ }
        function! s:get_neomake_joblist()
            redir => l:msg
            :silent! call neomake#ListJobs()
            redir END
            if empty(l:msg)
                return "No job is running!"
            else
                return l:msg
            endif
        endfunction

        nnoremap  <silent><leader>nj :cexpr <SID>get_neomake_joblist()<cr>:botright copen<cr>
    endfunction
    call te#feat#register_vim_enter_setting2([function('Neomake_setting')], ['neomake', 'neomake-multiprocess'])
else
    let g:grepper_plugin.cur_val = 'vim-easygrep'
endif
if g:grepper_plugin.cur_val ==# 'vim-easygrep'
    Plug 'dkprice/vim-easygrep',{'commit':'d0c36a77cc63c22648e792796b1815b44164653a'}
    let g:EasyGrepRecursive=1
    if te#env#Executable('rg')
        set grepprg=rg\ -H\ --no-heading\ --vimgrep\ $*
        let g:EasyGrepCommand='rg'
        set grepformat=%f:%l:%c:%m
    elseif te#env#Executable('ag')
        set grepprg=ag\ --nocolor\ --nogroup\ --vimgrep\ $*
        let g:EasyGrepCommand='ag'
        set grepformat=%f:%l:%c:%m
    elseif te#env#Executable('grep')
        set grepprg=grep\ -n\ $*\ /dev/null
        let g:EasyGrepCommand=1
    endif
    function s:search_in_opened_buffer()
        let g:EasyGrepMode=1
        execute 'normal '."\<plug>EgMapGrepCurrentWord_v"
        let g:EasyGrepMode=0
    endfunction
    function! Easygrep_mapping()
        map <silent> <Leader>vV <plug>EgMapGrepCurrentWord_v
        vmap <silent> <Leader>vV <plug>EgMapGrepSelection_v
        map <silent> <Leader>vv <plug>EgMapGrepCurrentWord_V
        vmap <silent> <Leader>vv <plug>EgMapGrepSelection_V
        map <silent> <Leader>vb :call <SID>search_in_opened_buffer()<cr>
        map <silent> <Leader>vi <plug>EgMapReplaceCurrentWord_r
        map <silent> <Leader>vI <plug>EgMapReplaceCurrentWord_R
        vmap <silent> <Leader>vi <plug>EgMapReplaceSelection_r
        vmap <silent> <Leader>vI <plug>EgMapReplaceSelection_R
        map <silent> <Leader>vo <plug>EgMapGrepOptions
        nnoremap  <Leader>vs :Grep 
    endfunction
    call te#feat#register_vim_enter_setting(function('Easygrep_mapping'))
endif
if get(g:, 'feat_enable_help') == 0
    Plug 'xolox/vim-session', {'on': ['OpenSession', 'SaveSession', 'DeleteSession']}
    Plug 'xolox/vim-misc', {'on': ['OpenSession', 'SaveSession', 'DeleteSession']}
    let g:session_autoload=0
    let g:session_autosave='no'
    let g:session_directory=$VIMFILES.'/sessions'
endif


if te#env#IsNvim() == 0
    if g:fuzzysearcher_plugin_name.cur_val ==# 'denite.nvim' ||
                \ g:complete_plugin_type.cur_val ==# 'deoplete.nvim' ||
                \ g:complete_plugin_type.cur_val ==# 'ncm2' ||
                \ g:file_explorer_plugin.cur_val ==# 'defx.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc', { 'do':'pip3 install --user pynvim'}
    endif
endif
"}}}
" Vimshell {{{
if !te#env#SupportTerminal() && !te#env#IsTmux()
    let g:vimshell_enable_smart_case = 1
    let g:vimshell_editor_command='gvim'
    let g:vimshell_prompt = '$ '
    if te#env#IsWindows()
        " Display user name on Windows.
        let g:vimshell_user_prompt = '$USERNAME." : ".fnamemodify(getcwd(), ":~").
                    \" [".b:vimshell.system_variables["status"]."]"'
    else
        " Display user name on Linux.
        let g:vimshell_user_prompt = '$USER." < ".te#git#get_cur_br_name().te#git#get_status()." \> "." : ".fnamemodify(getcwd(), ":~").
                    \" [".b:vimshell.system_variables["status"]."]"'
    endif

    "let g:vimshell_popup_command='rightbelow 10split'
    " Initialize execute file list.
    let g:vimshell_execute_file_list = {}
    silent! call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
    let g:vimshell_execute_file_list['rb'] = 'ruby'
    let g:vimshell_execute_file_list['pl'] = 'perl'
    let g:vimshell_execute_file_list['py'] = 'python'
    let g:vimshell_temporary_directory = $VIMFILES . '/.vimshell'
    silent! call vimshell#set_execute_file('html,xhtml', 'gexe firefox')
    let g:vimshell_split_command='tabnew'
    augroup vimshell_group
        autocmd!
        au FileType vimshell :imap <buffer> <HOME> <Plug>(vimshell_move_head) 
                    \ | :imap  <silent><buffer> <c-l> <Plug>(vimshell_clear)
                    \ | :imap  <silent><buffer> <c-k> <c-o>:stopinsert<cr>:call ctrlp#vimshell#start()<cr> 
                    \ | :imap  <silent><buffer> <up> <c-o>:stopinsert<cr>:call ctrlp#vimshell#start()<cr>
                    \ | :imap  <silent><buffer> <c-d> <Plug>(vimshell_exit)
                    \ | :imap  <silent><buffer> <c-j> <Plug>(vimshell_enter) 
                    \ | setlocal completefunc=vimshell#complete#omnifunc omnifunc=vimshell#complete#omnifunc 
                    \ buftype= nonu nornu 
                    \ | call vimshell#altercmd#define('g', 'git') 
                    \ | call vimshell#altercmd#define('i', 'iexe') 
                    \ | call vimshell#altercmd#define('ls', 'ls --color=auto') 
                    \ | call vimshell#altercmd#define('ll', 'ls -al --color=auto') 
                    \ | call vimshell#altercmd#define('l', 'ls -al --color=auto') 
                    \ | call vimshell#altercmd#define('gtab', 'gvim --remote-tab') 
                    \ | call vimshell#altercmd#define('c', 'clear') 
        "\| call vimshell#hook#add('chpwd', 'my_chpwd', 'g:my_chpwd')

        "function! g:my_chpwd(args, context)
        "call vimshell#execute('ls')
        "endfunction

        autocmd FileType int-* call s:interactive_settings()
    augroup END
    function! s:interactive_settings()
    endfunction
    if te#env#IsWin64()
        let g:vimproc#dll_path=$VIMRUNTIME.'/vimproc_win64.dll'
    elseif te#env#IsWin32()
        let g:vimproc#dll_path=$VIMRUNTIME.'/vimproc_win32.dll'
    endif
endif

"}}}
" Nerdtree {{{
let g:cursorword = 0

"remove mapping of * and # in mark.vim
nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext
nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev
nmap  <silent><leader>mm <Plug>MarkSet
xmap  <silent><Leader>mm <Plug>MarkSet
nmap  <silent><leader>mr <Plug>MarkRegex
xmap  <silent><Leader>mr <Plug>MarkRegex
nmap  <silent><leader>mn <Plug>MarkClear
xmap  <silent><leader>mn <Plug>MarkClear
nmap  <silent><leader>m? <Plug>MarkSearchAnyPrev
nmap  <silent><leader>m/ <Plug>MarkSearchAnyNext
"}}}
" Quickrun {{{
if te#env#SupportFloatingWindows() == 1
let g:quickrun_config = {
            \   '_' : {
            \       'outputter' : 'popup',
            \   },
            \}
else
let g:quickrun_config = {
            \   '_' : {
            \       'outputter' : 'quickfix',
            \   },
            \}
endif

let g:quickrun_no_default_key_mappings = 1
map  <silent><F6> <Plug>(quickrun)
vnoremap  <silent><F6> :'<,'>QuickRun<cr>
" run cunrrent file
nmap  <silent><leader>yr <Plug>(quickrun)
" run selection text
vnoremap  <silent><leader>yr :'<,'>QuickRun<cr>
" }}}
" Misc {{{
if te#env#SupportAsync()
    let g:love_support_option=['termguicolors', 'tabstop', 'shiftwidth', 'softtabstop', 'expandtab', 'smarttab']
endif
" Save basic setting
nnoremap  <silent><Leader>lo :Love<cr>
nnoremap  <silent><Leader>ts :call te#tools#run_sexy_command()<cr>


if g:enable_sexy_mode.cur_val ==# 'on'
    call te#feat#register_vim_enter_setting(function('te#tools#run_sexy_command'))
endif



" }}}
