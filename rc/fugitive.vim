
if !te#env#check_requirement()
    Plug 'tpope/vim-fugitive', {'tag': 'v2.2', 'on': []}
    Plug 'gregsexton/gitv', { 'on': 'Gitv' }
    nnoremap  <silent><F3> :silent! only<cr>:Gstatus<cr>
    nnoremap  <silent><Leader>gs :silent! only<cr>:Gstatus<cr>
else
    if te#env#IsNvim() != 0 || has('patch-8.2.3141')
        Plug 'tpope/vim-fugitive', {'dir': g:vinux_plugin_dir.cur_val.'/vim-fugitive-latest/', 'on': []}
    else
        Plug 'tpope/vim-fugitive', {'tag': 'v3.2', 'on': []}
    endif
    " Open git status window
    nnoremap  <silent><F3> :silent! only<cr>:G<cr>:call feedkeys(']]')<cr>
    nnoremap  <silent><Leader>gs :silent! only<cr>:G<cr>:call feedkeys(']]')<cr>
endif
call te#feat#register_vim_enter_setting2([0], ['vim-fugitive'])
Plug 'sodapopcan/vim-twiggy', { 'on': 'Twiggy' }
let g:fugitive_no_maps=0
nnoremap  <silent><Leader>sb :Twiggy<cr>
" Open git blame windows
nnoremap  <silent><Leader>gb :Git blame<cr>
" git diff current file (vimdiff)
nnoremap  <silent><Leader>gd :Gdiff<cr>
" git cd
nnoremap  <silent><Leader>gc :Gcd<cr>
" git config -e
nnoremap  <silent><Leader>ge :Gcd<cr>:sp .git/config<cr>
" Open github url
nnoremap  <silent><Leader>gh :call te#git#git_browse()<cr>
