#!/usr/bin/python3

import qmk_compiler
import json
import pathlib
import os

pathlib.Path('qmk_firmware/keyboards/iris/rev2/keymaps').mkdir(parents=True, exist_ok=True)

data = json.load(open('iris_rev2_layout_mine.json'))
keyboard = data['keyboard']
layout = data['layout']
keymap = data['keymap']
layers = data['layers']

result = {
    'keyboard': keyboard,
    'layout': layout,
    'keymap': keymap,
    'command': ['make', 'COLOR=false', ':'.join((keyboard, keymap))],
    'returncode': -2,
    'output': '',
    'firmware': None,
    'firmware_filename': ''
}

qmk_compiler.create_keymap(result, layers)

os.execv('/bin/cat', ['/bin/cat', 'qmk_firmware/keyboards/iris/rev2/keymaps/iris_rev2_layout_mine/keymap.c'])
