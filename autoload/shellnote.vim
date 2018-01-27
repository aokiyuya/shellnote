" shellnote
" Author: Yuya Aoki
"

scriptencoding utf-8

let s:shellnote_server = expand('<sfile>:p:h').'/shellnotelib.py'
let s:shellnotelib_dir = expand('<sfile>:p:h').''

function! shellnote#bash_out() abort
	let a:cmd = getline('.')
	if a:cmd[0] == '>'
		let a:cmd = a:cmd[1:]
	endif
	if matchstr(a:cmd, '[a-z]') == ''
		return ''
	endif
python3 << EOF
import sys
import vim
shellnotelib_dir = vim.eval('s:shellnotelib_dir')
sys.path.append(shellnotelib_dir)
splittag = vim.eval('s:shellnote_splittag')
import shellnotelib as shl
result = shl.server_send('add_hist' + splittag + vim.eval('a:cmd'), int(vim.eval('b:shellnote_port')))
print(result)
EOF
	normal! o
	execute ":r! ".a:cmd
	call append('.', "> ")
	let a:pos = getpos('.')
	let a:pos[1] = a:pos[1] + 1
	call setpos('.', a:pos)
	normal! $
endfunction

function! shellnote#previous_command(...) abort
	if a:0 >= 1
		let a:now_corsor = a:1
	else
		let a:now_corsor = line('.')
		echo a:now_corsor
	end
python3 << EOF
import sys
import vim
shellnotelib_dir = vim.eval('s:shellnotelib_dir')
sys.path.append(shellnotelib_dir)
splittag = vim.eval('s:shellnote_splittag')
import shellnotelib as shl
result = shl.server_send('load_prev_hist' + splittag, int(vim.eval('b:shellnote_port')))
vim.command("let a:prev = \"" + result + "\"")
EOF
	" execute ":normal G".a:now."S" . a:prev
	call setline(a:now_corsor, '>'.a:prev)
	normal! $
endfunction

function!  shellnote#init_command_hist() abort
	let b:shellnote_port = localtime()%10000 + 30000
	let s:shellnote_splittag = "<shellnote_split>"
	let b:shellnote_pref = localtime()
	let b:shellnore_filename = expand('%:p')
	" let b:shellnore_procid = 0
	" サーバー立ち上げ
	let a:command = ":!python ".s:shellnote_server.' '.b:shellnote_port." &"
	call execute(a:command)
endfunction

function! shellnote#kill() abort
	call execute(":!ps | grep shellnotelib.py | grep ".b:shellnote_port."| awk '$0=$1' | xargs kill -KILL")
endfunction

