"lsp function wrapper

function! te#lsp#is_server_running() abort
    if te#env#IsNvim() >= 0.5
        return v:lua.require('utils').is_lsp_running()
    else
        if exists("*lsp#get_server_status")
            let l:ret = 0
            let l:serve_name = lsp#get_allowed_servers()
            for l:needle in l:serve_name
                let l:ret += !empty(lsp#get_server_status(l:needle))
            endfor
            return l:ret
        endif
    endif
    return 0
endfunction

function! te#lsp#gotodefinion() abort
    if exists(':LspDefinition') == 2
        :LspDefinition
        return 0
    elseif te#env#IsNvim() >= 0.5
        :lua vim.lsp.buf.definition()
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
    return 0
endfunction

"format entire document
function! te#lsp#format_document() abort
    if exists(':LspDocumentFormatSync') == 2
        :LspDocumentFormatSync
        return 0
    elseif te#env#IsNvim() >= 0.5
        :lua vim.lsp.buf.range_formatting()
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
    return 0
endfunction

function! te#lsp#format_document_range() abort
    if exists(':LspDocumentRangeFormatSync') == 2
        :LspDocumentRangeFormatSync
        return 0
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#hover() abort
    if exists(':LspHover') == 2
        :LspHover
        return 0
    elseif te#env#IsNvim() >= 0.5
        :lua vim.lsp.buf.hover()
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#find_implementation() abort
    if exists(':LspImplementation') == 2
        :LspImplementation
        return 0
    elseif te#env#IsNvim() >= 0.5
        :lua vim.lsp.buf.implementation()
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#references() abort
    if exists(':LspReferences') == 2
        :LspReferences
        return 0
    elseif te#env#IsNvim() >= 0.5
        :lua vim.lsp.buf.references()
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
    return 0
endfunction

function! te#lsp#rename() abort
    if exists(':LspRename') == 2
        :LspRename
        return 0
    elseif te#env#IsNvim() >= 0.5
        :lua vim.lsp.buf.rename()
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#goto_type_def() abort
    if exists(':LspTypeDefinition') == 2
        :LspTypeDefinition
        return 0
    elseif te#env#IsNvim() >= 0.5
        :lua vim.lsp.buf.type_definition()
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction
