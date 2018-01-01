" shellnote
" Author: Yuya Aoki
"

scriptencoding utf-8

function! shellnote#bashOut() abort
	let s:cmd = getline('.')
	if s:cmd[0] == '>'
		let s:cmd = s:cmd[1:]
	endif
	normal! o
	execute ":r! ".s:cmd
	call append('.', "> ")
	let s:pos = getpos('.')
	let s:pos[1] = s:pos[1] + 1
	call setpos('.', s:pos)
	normal! $
endfunction

function! shellnote#previous_command() abort
	let s:now = getline('.')
	echo search(s:now)
	" let s:prev = getline('.')
python3 << PYTHON
prev = history.get_prev_hist()
vim.command('let s:prev = ' + prev)
print(prev)

PYTHON
	execute ":normal S" . s:prev
	normal! $
endfunction

function!  shellnote#init_command_hist() abort
python3 << PYTHON
import vim
import sys
import os
sys.path.append(os.path.expanduser('~') + '/.vim/after/ftplugin')
import shellnotelib as sn
history = sn.ShellNote()
PYTHON
endfunction

