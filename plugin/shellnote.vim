" call bash and paste the output on markdown file
" Author: Yuya Aoki
" License: MIT


if exists('g:loaded_shellnote')
  finish
endif

let g:loaded_shellnote = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 ShellnoteInit call shellnote#init_command_hist()
command! -nargs=? ShellnotePrev call shellnote#previous_command(<f-args>)

augroup shellnote
	autocmd!
	autocmd VimLeave * call shellnote#kill()
augroup END

ShellnoteInit

nnoremap <Leader>@ :call shellnote#bash_out()<CR>
nnoremap <C-p> :ShellnotePrev<CR>


let &cpo = s:save_cpo
unlet s:save_cpo
