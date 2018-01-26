" call bash and paste the output on markdown file
" Author: Yuya Aoki
" License: MIT


if exists('g:loaded_shellnote')
  finish
endif

let g:loaded_shellnote = 1

let s:save_cpo = &cpo
set cpo&vim

augroup shellnote
	autocmd!
	autocmd VimEnter :call shellnote#init_command_hist()<CR>
augroup END

nnoremap <Leader>@ :call shellnote#bash_out()<CR>
nnoremap <C-p> <C-o>:call shellnote#previous_command()<CR>


let &cpo = s:save_cpo
unlet s:save_cpo
