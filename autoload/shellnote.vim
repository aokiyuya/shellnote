" shellnote
" Author: Yuya Aoki
"

scriptencoding utf-8

let s:shellnote_port = 2828
let s:shellnote_server = expand('<sfile>:p:h').'shellnotelib.py'

function! shellnote#bash_out() abort
	let a:cmd = getline('.')
	if a:cmd[0] == '>'
		let a:cmd = a:cmd[1:]
	endif
	normal! o
	execute ":r! ".a:cmd
	call append('.', "> ")
	let a:pos = getpos('.')
	let a:pos[1] = a:pos[1] + 1
	call setpos('.', s:pos)
	normal! $
endfunction

function! shellnote#previous_command() abort
	let a:now = getline('.')
	echo search(a:now)
	execute ":normal S" . a:prev
	normal! $
endfunction

function!  shellnote#init_command_hist() abort
	let b:shellnote_pref = localtime()
	let b:shellnore_filename = expand('%:p')
	let b:shellnore_procid = 0
	echo "test"
	" サーバー立ち上げ
	execute ":! python ".s:shellnote_server." &"
endfunction

function! shellnote#kill() abort
	execute ":!kill -KILL ".b:shellnore_procid
endfunction

