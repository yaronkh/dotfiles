#!/usr/bin/env python3
import subprocess
import sys
import re

class display:
    def __init__(self, rx, ry, x):
        self.rx = rx
        self.ry = ry
        self.x = x

    def __lt__(self, other):
        return self.x < other.x

def get_mouse_xpos():
    x = -1
    y = -1
    for s in subprocess.check_output(["xdotool", "getmouselocation", "--shell"]).decode("utf-8").split("\n"):
        param, val = s.split('=')
        if param == "X":
            x = int(val)
        elif param == "Y":
            y = int(val)
        if x >= 0 and y >= 0:
            return (x,y)
    raise ("mouse X coordinate not found")

screen_data_re = re.compile('([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+)')

all_displays = []

for s in subprocess.check_output("xrandr").decode("utf-8").split('\n'):
    m = screen_data_re.search(s)
    if m:
        dat =  [ int(a) for a in m.groups()]
        all_displays.append(display(dat[0], dat[1], dat[2]))

all_displays.sort()

mx, my = get_mouse_xpos()

nd = -1

for i, dsp in enumerate(all_displays):
    if mx >= dsp.x and mx < dsp.x + dsp.rx:
        if sys.argv[1] == "right":
            nd = all_displays[(i + 1) % len(all_displays)]
        else:
            nd = all_displays[(i - 1) % len(all_displays)]
        break

dx = mx - dsp.x
if dx >= nd.rx:
    dx = nd.rx - 1
if my >= nd.ry:
    my = nd.ry - 1

coordx = dx + nd.x
subprocess.check_output(["xdotool", "mousemove", str(coordx), str(my)])
#subprocess.check_output(["xdtool", "click"])
