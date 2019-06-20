"fzf feature for vinux
"author:<tracyone tracyone@live.cn>

let s:text = []
let s:enable_flag= 0

function! te#fzf#feat#get_var_value(A, L, P) abort
    let l:result=''
    for l:needle in s:var_candidate
        let l:result.=l:needle.nr2char(10)
    endfor
    return l:result
endfunction

function! s:edit_file(item)
    let l:pos = stridx(a:item, ' ')
    let l:str = a:item[pos+1:-1]
    if s:enable_flag == 1
        let l:enable='Enable'
    else
        let l:enable='Disable'
    endif
    let l:feat_dict=te#feat#get_feature_dict()
    if l:str !=# 'all'
        if type(eval(l:str))
            let s:var_candidate=[]
            let l:feat_candidate=eval(matchstr(l:str,'.*\(\.cur_val\)\@=').'.candidate')
            call extend(s:var_candidate,l:feat_candidate)
            let l:str=input('Input the value of '.l:str.': ', '', 'custom,te#fzf#feat#get_var_value')
            let l:feat_dict[l:str]=string(l:str)
            execute 'let '.l:str.'='.string(l:str)
            call te#feat#gen_feature_vim(0)
            call te#utils#EchoWarning('Set '.l:str.' to '.string(l:str).' successfully!')
            return
        else
            let l:feat_dict[l:str]=s:enable_flag
            execute 'let '.l:str.'='.s:enable_flag
            call te#feat#gen_feature_vim(0)
            call te#feat#feat_enable(l:str,eval(l:feat_dict[l:str]))
        endif
    else
        for l:key in keys(l:feat_dict)
            if type(eval(l:key)) != g:t_string
                let l:feat_dict[l:key]=s:enable_flag
                execute 'let '.l:key.'='.s:enable_flag
                call te#feat#feat_enable(l:key,eval(l:feat_dict[l:key]))
            endif
        endfor
        call te#feat#gen_feature_vim(0)
    endif
    if s:enable_flag == 1 | :PlugInstall --sync | q | endif
    call te#utils#EchoWarning(l:enable.' '.l:str.' successfully!')
endfunction

function! te#fzf#feat#start(en) abort
    for l:key in keys(te#feat#get_feature_dict())
        call add(s:text, l:key)
    endfor
    call add(s:text, 'all')
    let s:enable_flag=a:en
    call fzf#run({
                \ 'source': s:text, 
                \ 'sink': function('<SID>edit_file'),
                \ 'down':'40%' ,
                \ })
endfunction