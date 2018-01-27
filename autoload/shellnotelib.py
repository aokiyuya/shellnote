#! !(which python)
# coding: utf-8
###########################
# Author: Yuya Aoki
#
###########################
import re
from collections import deque
import socket
import os
import sys


class Shellnote(object):
    def __init__(self, filename=None):
        if filename is None:
            filename = os.path.expanduser('~') + '/.bash_history'
        self.command_hist = deque()
        self.fileread(filename)

    def fileread(self, filename):
        with open(filename) as fp:
            for line in fp.readlines():
                self.command_hist.append(line)
        self.save_hist_index(len(self.command_hist))

    def add_hist(self, command):
        if command in self.command_hist:
            self.command_hist.remove(command)
        self.command_hist.append(command)
        self.save_hist_index(len(self.command_hist))
        # 通信する際に一貫性をとるため文字列を返す
        return 'SUCCESS'

    def load_prev_hist(self, now_command=None):
        if now_command is not None:
            self.index = self.command_hist.index(now_command)
        if self.index > 0:
            self.index = self.index - 1
        return self.command_hist[self.index]

    def load_new_hist(self, now_command=None):
        if now_command is None:
            if self.index < len(self.command_hist) - 2:
                self.index = self.index + 1
        else:
            self.index = self.command_hist.index(now_command)
        return self.command_hist[self.index]

    def save_hist_index(self, index):
        self.index = index


def command_classify(string, shellnote):
    command, args = string.split('<shellnote_split>')
    # print(command, '<>', args, '<>')
    if re.match('^\s*$', args):
        args = ''
    else:
        args = '\'' + args + '\''
    # print(dir(shellnote))
    if command in dir(shellnote):
        return eval("shellnote." + command + '(' + args + ')')
    return 'None'


def server_start(port=2828):
    host = ''
    shellnote = Shellnote()
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server:
        server.bind((host, port))
        server.listen(2)
        while True:
            client_socket, address = server.accept()
            recv_data = client_socket.recv(1024).decode('utf-8')
            if re.match('^exit', recv_data):
                break
            result = command_classify(recv_data, shellnote)
            # print(result)
            client_socket.sendall(result.encode('utf-8'))
        # print(recv_data)
        client_socket.sendall('SUCCESS'.encode('utf-8'))


def server_send(msg, port=2828):
    host = ''
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect((host, port))
        s.sendall(msg.encode('utf-8'))
        data = s.recv(1024)
    # print(data.decode('utf-8'))
    return data.decode('utf-8')


if __name__ == '__main__':
    # print(sys.argv)
    server_start(int(sys.argv[1]))
# EOF
