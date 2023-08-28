"just for fun ...
Plug 'itchyny/thumbnail.vim',{'on': 'Thumbnail'}
Plug 'itchyny/calendar.vim', { 'on': 'Calendar'}
Plug 'johngrib/vim-game-code-break', {'on': 'VimGameCodeBreak'}
Plug 'johngrib/vim-game-snake', {'on': 'VimGameSnake'}
Plug 'vim/killersheep', {'on': 'KillKillKill'}
Plug 'iqxd/vim-mine-sweeping', {'on': 'MineSweep', 'branch': 'main'}

" open calendar
nnoremap  <silent><Leader>ad :Calendar<cr>
nnoremap  <silent><Leader>ap :Thumbnail<cr>

if !te#env#SupportTimer()
    :finish
endif

Plug 'itchyny/screensaver.vim'

"config ...
function! s:fun_setting()
    let g:screensaver_password = 1
    let s:password=strftime('%Y%m%d')
    silent! call screensaver#source#password#set(sha256(s:password))
    nnoremap  <silent><Leader>ar :call <SID>enter_screen_saver(0)<cr>
endfunction
call te#feat#register_vim_enter_setting(function('<SID>fun_setting'))

" 1500000 ms (45 mins)
let s:expires_time=2700000
" 120000 ms (10 mins) for rest time
let s:rest_time=120000
let s:main_timer=-1

function! s:rest_exit(timer)
    call timer_info(a:timer)
    call feedkeys("\<c-[>")
    call feedkeys("\<c-[>")
    call feedkeys("\<c-[>")
    call feedkeys("\<cr>")
    call feedkeys(s:password)
    call feedkeys("\<cr>")
    let s:main_timer=timer_start(str2nr(s:expires_time), function('<SID>enter_screen_saver'), {'repeat': 1})
endfunction

function! s:enter_screen_saver(timer)
    call timer_info(a:timer)
    call feedkeys("\<c-[>")
    call timer_stop(s:main_timer)
    if a:timer != 0
        call timer_start(str2nr(s:rest_time), function('<SID>rest_exit'), {'repeat': 1})
    endif
    :ScreenSaver largeclock
    call feedkeys("\<c-[>")
    silent! call s:smile()
endfunction

function! s:smile()
    if te#env#SupportFloatingWindows() == 1
        let l:list=split(execute("smile"), '\n')
        call add(l:list,"\t\t\t\t Today is ".strftime("%Y%m%d"))
        silent call popup_create(l:list, {
                    \ 'line': 0,
                    \ 'col': 0,
                    \ 'time': 5000,
                    \ 'tab': -1,
                    \ 'zindex': 200,
                    \ 'highlight': 'pmenu',
                    \ 'maxwidth': &columns,
                    \ 'border': [0,0,0,0],
                    \ })
    endif
endfunction

let s:game_list = ['VimGameCodeBreak', 'VimGameSnake', 'KillKillKill', 'MineSweep']
let s:game_index = -1

function! s:game_start(timer) abort
    if s:game_index >= 0
        set laststatus=0
        set showtabline=0
        set nonumber norelativenumber nocursorline nocursorcolumn
        set nowrap
        execute s:game_list[s:game_index]
    endif
endfunction
function GameSelect(result)
    let s:game_index = a:result - 1
    call timer_start(50, function('<SID>game_start'), {'repeat': 1})
endfunc

function! s:start_vinux_game_center() abort
    call te#utils#confirm("Select a game to start!", s:game_list, function('GameSelect'))
endfunction
nnoremap  <silent><Leader>ag :call <SID>start_vinux_game_center()<cr>

let s:main_timer=timer_start(str2nr(s:expires_time), function('<SID>enter_screen_saver'), {'repeat': 1})
