function! s:delete_file(confirm)
    let l:lastline = line("'>")
    let l:curLine = line("'<")
    if l:curLine == l:lastline
        let l:curLine = line(".")
        let l:lastline = l:curLine
    endif
    while l:curLine <= l:lastline
        call cursor(l:curLine, 1)
        let l:file = g:NERDTreeFileNode.GetSelected()
        if !empty(l:file)
            if !empty(l:file.path)
                if a:confirm == 0 || (confirm("Delete ".l:file.path.str(), "&Yes\n&No", 2)==1)
                    try 
                        call l:file.delete()
                    catch
                        call te#utils#EchoWarning("Delete ".l:file.path.str()." fail", 'err')
                    endtry
                endif
            endif
        endif
        let l:curLine += 1
    endwhile
    call l:file.parent.refresh()
    call NERDTreeRender()
endfunction

function! s:new_file()
    let curDirNode = g:NERDTreeDirNode.GetSelected()
    let l:newNodeName = input("Please input a new filename: ", "", 'file')

    if l:newNodeName ==# ''
        call te#utils#EchoWarning('Empty filename!')
        return
    endif

    let l:newNodeName =curDirNode.path.str().nerdtree#slash().l:newNodeName

    try
        let newPath = g:NERDTreePath.Create(l:newNodeName)
        let parentNode = b:NERDTree.root.findNode(newPath.getParent())

        let newTreeNode = g:NERDTreeFileNode.New(newPath, b:NERDTree)
        " Emptying g:NERDTreeOldSortOrder forces the sort to
        " recalculate the cached sortKey so nodes sort correctly.
        let g:NERDTreeOldSortOrder = []
        if empty(parentNode)
            call b:NERDTree.root.refresh()
            call b:NERDTree.render()
        elseif parentNode.isOpen || !empty(parentNode.children)
            call parentNode.addChild(newTreeNode, 1)
            call NERDTreeRender()
            call newTreeNode.putCursorHere(1, 0)
        endif

        redraw!
    catch /^NERDTree/
        call te#utils#EchoWarning("Create ".l:newNodeName." fail!", 'err')
    endtry
endfunction

function! s:open_file()
    let l:node = g:NERDTreeFileNode.GetSelected()

    if empty(l:node)
        return
    endif
    if te#env#IsWindows()
        call system('cmd /C start ' . shellescape(l:node.path.str()))
    elseif te#env#IsMac()
        call system("open '" . shellescape(l:node.path.str()) . "'")
    else
        call system("xdg-open '" . shellescape(l:node.path.str()) . "' &")
    endif
endfunction

let s:copy_file_path = []
function! s:copy_file()
    let l:lastline = line("'>")
    let l:curLine = line("'<")
    if l:curLine == l:lastline
        let l:curLine = line(".")
        let l:lastline = l:curLine
    endif
    while l:curLine <= l:lastline
        call cursor(l:curLine, 1)
        let l:node = g:NERDTreeFileNode.GetSelected()
        call add(s:copy_file_path, substitute(l:node.path.str(), '\/$', '', ''))
        let l:curLine += 1
    endwhile
    call setreg('*', l:node.path.str())
    call te#utils#EchoWarning("Copy ".len(s:copy_file_path)." files")
endfunction

let s:move_file_path = []
function! s:move_file()
    let l:lastline = line("'>")
    let l:curLine = line("'<")
    if l:curLine == l:lastline
        let l:curLine = line(".")
        let l:lastline = l:curLine
    endif
    while l:curLine <= l:lastline
        call cursor(l:curLine, 1)
        let l:node = g:NERDTreeFileNode.GetSelected()
        call add(s:move_file_path, substitute(l:node.path.str(), '\/$', '', ''))
        let l:curLine += 1
    endwhile
    call setreg('*', l:node.path.str())
    call te#utils#EchoWarning("Copy ".len(s:move_file_path).' files path!')
endfunction

function! s:paste_file()
    let l:confirm = 1
    let l:node = g:NERDTreeFileNode.GetSelected()

    for l:path in s:copy_file_path
        let l:dst_file = fnamemodify(l:node.path.str(), ":p:h").nerdtree#slash().fnamemodify(l:path, ":t")
        let l:ret = te#file#copy_file(l:path, l:dst_file)
    endfor
    let s:copy_file_path = []

    for l:path in s:move_file_path
        let l:dst_file = fnamemodify(l:node.path.str(), ":p:h").nerdtree#slash().fnamemodify(l:path, ":t")
        if filereadable(l:dst_file)
            if confirm(l:dst_file." is exist! override?", "&Yes\n&No", 2) == 2
                call te#utils#EchoWarning("Move file abort")
                let l:confirm = 0
            endif
        endif
        if l:confirm == 1
            let l:ret = rename(l:path, l:dst_file)
            if l:ret
                call te#utils#EchoWarning("Move file to".l:dst_file." fail!!", 'err')
            else
                call te#utils#EchoWarning("Move file finish")
            endif
        endif
    endfor
    let s:move_file_path = []
    call b:NERDTree.root.refresh()
    "call l:node.parent.refresh()
    call NERDTreeRender()
endfunction

function! s:rename_file()
    let l:node = g:NERDTreeFileNode.GetSelected()
    let l:newNodeName = input("Please input a new filename: ", fnamemodify(l:node.path.str(), ":t"), 'file')

    let l:newNodeName = fnamemodify(l:node.path.str(), ":p:h").nerdtree#slash().l:newNodeName
    if l:newNodeName ==# ''
        call te#utils#EchoWarning('Empty filename!')
        return
    endif
    let l:ret = rename(l:node.path.str(), l:newNodeName)
    if l:ret
        call te#utils#EchoWarning("Rename file from ".l:node.path.str()." to ".l:newNodeName." fail", 'err')
    else
        call te#utils#EchoWarning("Rename file finish")
    endif
    call l:node.parent.refresh()
    call NERDTreeRender()
endfunction

nnoremap <silent><buffer> O :call <SID>open_file()<cr>

nnoremap <silent><buffer> dd :call <SID>delete_file(1)<cr>
xnoremap <silent><buffer> dd :<c-u>:call <SID>delete_file(1)<cr>
nnoremap <silent><buffer> D :call <SID>delete_file(0)<cr>
xnoremap <silent><buffer> D :<c-u>:call <SID>delete_file(0)<cr>

nnoremap <silent><buffer> yy :call <SID>copy_file()<cr>
xnoremap <silent><buffer> y :<c-u>:call <SID>copy_file()<cr>

xnoremap <silent><buffer> m :<c-u>:call <SID>move_file()<cr>
nnoremap <silent><buffer> m :call <SID>move_file()<cr>

nnoremap <silent><buffer> N :call <SID>new_file()<cr>
nnoremap <silent><buffer> p :call <SID>paste_file()<cr>
nnoremap <silent><buffer> r :call <SID>rename_file()<cr>


