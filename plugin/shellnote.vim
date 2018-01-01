" call bash and paste the output on markdown file
" Author: Yuya Aoki
" License: MIT


if exists('g:loaded_shellnote')
  finish
endif

let g:loaded_shellnote = 1


augroup shellnote
	autocmd!
	autocmd VimEnter :call InitCommandHist()<CR>
augroup END

nnoremap <Leader>@ :call BashOut()<CR>
nnoremap <C-p> <C-o>:call Previous_command()<CR>
"
