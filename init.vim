" packadd quickscope

let mapleader = " "



" execute 'luafile ' . stdpath('config') . '/lua/settings.lua'
function! s:manageEditorSize(...)
    let count = a:1
    let to = a:2
    for i in range(1, count ? count : 1)
        call VSCodeNotify(to == 'increase' ? 'workbench.action.increaseViewSize' : 'workbench.action.decreaseViewSize')
    endfor
endfunction

function! s:vscodeCommentary(...) abort
    if !a:0
        let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
        return 'g@'
    elseif a:0 > 1
        let [line1, line2] = [a:1, a:2]
    else
        let [line1, line2] = [line("'["), line("']")]
    endif

    call VSCodeCallRange("editor.action.commentLine", line1, line2, 0)
endfunction

function! s:openVSCodeCommandsInVisualMode()
    normal! gv
    let visualmode = visualmode()
    if visualmode == "V"
        let startLine = line("v")
        let endLine = line(".")
        call VSCodeNotifyRange("workbench.action.showCommands", startLine, endLine, 1)
    else
        let startPos = getpos("v")
        let endPos = getpos(".")
        call VSCodeNotifyRangePos("workbench.action.showCommands", startPos[1], endPos[1], startPos[2], endPos[2], 1)
    endif
endfunction

function! s:openWhichKeyInVisualMode()
    normal! gv
    let visualmode = visualmode()
    if visualmode == "V"
        let startLine = line("v")
        let endLine = line(".")
        call VSCodeNotifyRange("whichkey.show", startLine, endLine, 1)
    else
        let startPos = getpos("v")
        let endPos = getpos(".")
        call VSCodeNotifyRangePos("whichkey.show", startPos[1], endPos[1], startPos[2], endPos[2], 1)
    endif
endfunction

" custom mapping 
nnoremap <Esc> :noh <CR>
nmap <leader>h <C-w>h 
nmap <leader>l <C-w>l 
nmap <leader>j <C-w>j 
nmap <leader>k <C-w>k
nmap <leader>s :vsp <CR>
nmap <leader>f :call VSCodeNotify("workbench.action.quickOpen")<CR>
nnoremap <leader>1 :call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR> 
nnoremap <leader>e :call VSCodeNotify("workbench.view.explorer")<CR>
nmap <leader>x :tabc <CR>
nnoremap <leader>t :call VSCodeNotify('workbench.action.focusActiveEditorGroup')<CR>:call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR>

nnoremap gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>






" Toggle the search view in VSCode
nnoremap <leader>ff :call VSCodeNotify("workbench.action.findInFiles")<CR>





" Bind C-/ to vscode commentary since calling from vscode produces double comments due to multiple cursors
xnoremap <expr> <C-/> <SID>vscodeCommentary()
nnoremap <expr> <C-/> <SID>vscodeCommentary() . '_'

nnoremap <silent> <C-w>_ :<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>

nnoremap <silent> ; :call VSCodeNotify('whichkey.show')<CR>
xnoremap <silent> ; :<C-u>call <SID>openWhichKeyInVisualMode()<CR>

xnoremap <silent> <C-P> :<C-u>call <SID>openVSCodeCommandsInVisualMode()<CR>

xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

" Ensure this is placed in your init.vim
imap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

set clipboard=unnamedplus
set ignorecase
