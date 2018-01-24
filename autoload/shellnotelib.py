#! !(which python)
# coding: utf-8
###########################
# Author: Yuya Aoki
#
###########################
import re
from collections import deque


class ShellNote(object):
    def __init__(self, filename):
        self.command_hist = deque()
        with open(filename) as fp:
            for line in fp.readlines():
                if re.match('^>', line):
                    # line.replace('^>\s*')
                    self.command_hist.append(line)
        self.set_hist_index(len(self.command_hist))

    def add_hist(self, command):
        if command in self.command_hist:
            self.command_hist.remove(command)
        self.command_hist.append(command)
        self.set_hist_index(len(self.command_hist))

    def get_prev_hist(self, now_command=None):
        if now_command is None:
            index = self.index
        else:
            index = self.command_hist.index(now_command)
        if index > 0:
            index = index - 1
        return self.command_hist[index]

    def get_new_hist(self, now_command):
        hist_size = len(self.command_hist)
        index = self.command_hist.index(now_command)
        if index < hist_size:
            return self.command_hist[index - 1]
        else:
            return self.command_hist[index]

    def set_hist_index(self, index):
        self.index = index


def server_init():
    pass


if __name__ == '__main__':
    # server_init()
    print("test")
# EOF
