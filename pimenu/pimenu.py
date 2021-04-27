#!/usr/bin/python2
# -*- coding: utf-8 -*-
import Tkconstants as TkC
import os
import subprocess
import sys
from Tkinter import Tk, Frame, Button, Label, PhotoImage
from math import sqrt, floor, ceil

import yaml

def pi_apps_mainpage():
	os.system("x-www-browser https://github.com/botspot/pi-apps >/dev/null &")
	quit()
class FlatButton(Button):
    def __init__(self, master=None, cnf=None, **kw):
        Button.__init__(self, master, cnf, **kw)

        self.config(
            compound=TkC.TOP,
            relief=TkC.FLAT,
            bd=0,
            bg="#b91d47",  # dark-red
            fg="white",
            activebackground="#b91d47",  # dark-red
            activeforeground="white",
            highlightthickness=0
        )

    def set_color(self, color):
        self.configure(
            bg=color,
            fg="white",
            activebackground=color,
            activeforeground="white"
        )


class PiMenu(Frame):
    framestack = []
    icons = {}
    path = ''
    lastinit = 0

    def __init__(self, parent):
        Frame.__init__(self, parent, background="white")
        self.parent = parent
        self.pack(fill=TkC.BOTH, expand=1)

        self.path = os.path.dirname(os.path.realpath(sys.argv[0]))
        self.initialize()

    def initialize(self):
        """
        (re)load the the items from the yaml configuration and (re)init
        the whole menu system

        :return: None
        """
        with open(self.path + '/pimenu.yaml', 'r') as f:
            doc = yaml.load(f)
        self.lastinit = os.path.getmtime(self.path + '/pimenu.yaml')

        if len(self.framestack):
            self.destroy_all()
            self.destroy_top()

        self.show_items(doc)

    def has_config_changed(self):
        """
        Checks if the configuration has been changed since last loading

        :return: Boolean
        """
        return self.lastinit != os.path.getmtime(self.path + '/pimenu.yaml')

    def show_items(self, items, upper=None):
        """
        Creates a new page on the stack, automatically adds a back button when there are
        pages on the stack already

        :param items: list the items to display
        :param upper: list previous levels' ids
        :return: None
        """
        if upper is None:
            upper = []
        num = 0

        # create a new frame
        wrap = Frame(self, bg="black")

        if len(self.framestack):
            # when there were previous frames, hide the top one and add a back button for the new one
            self.hide_top()
            back = FlatButton(
                wrap,
                text='back…',
                image=self.get_icon("arrow.left"),
                command=self.go_back,
            )
            back.set_color("#00a300")  # green
            back.grid(row=0, column=0, padx=1, pady=1, sticky=TkC.W + TkC.E + TkC.N + TkC.S)
            num += 1

        # add the new frame to the stack and display it
        self.framestack.append(wrap)
        self.show_top()

        # calculate tile distribution
        allitems = len(items) + num
        rows = floor(sqrt(allitems))
        cols = ceil(allitems / rows)

        # make cells autoscale
        for x in range(int(cols)):
            wrap.columnconfigure(x, weight=1)
        for y in range(int(rows)):
            wrap.rowconfigure(y, weight=1)

        # display all given buttons
        for item in items:
            act = upper + [item['name']]

            if 'icon' in item:
                image = self.get_icon(item['icon'])
            else:
                image = self.get_icon('scrabble.' + item['label'][0:1].lower())

            btn = FlatButton(
                wrap,
                text=item['label'],
                image=image
            )

            if 'items' in item:
                # this is a deeper level
                btn.configure(command=lambda act=act, item=item: self.show_items(item['items'], act),
                              text=item['label'] + '…')
                btn.set_color("#2b5797")  # dark-blue
            else:
                # this is an action
                btn.configure(command=lambda act=act: self.go_action(act), )

            if 'color' in item:
                btn.set_color(item['color'])

            # add buton to the grid
            btn.grid(
                row=int(floor(num / cols)),
                column=int(num % cols),
                padx=1,
                pady=1,
                sticky=TkC.W + TkC.E + TkC.N + TkC.S
            )
            num += 1

    def get_icon(self, name):
        """
        Loads the given icon and keeps a reference

        :param name: string
        :return:
        """
        if name in self.icons:
            return self.icons[name]

        ico = name
        if not os.path.isfile(ico):
            ico = self.path + '/ico/' + name + '.gif'
            if not os.path.isfile(ico):
                ico = self.path + '/ico/cancel.gif'

        self.icons[name] = PhotoImage(file=ico)
        return self.icons[name]

    def hide_top(self):
        """
        hide the top page
        :return:
        """
        self.framestack[len(self.framestack) - 1].pack_forget()

    def show_top(self):
        """
        show the top page
        :return:
        """
        self.framestack[len(self.framestack) - 1].pack(fill=TkC.BOTH, expand=1)

    def destroy_top(self):
        """
        destroy the top page
        :return:
        """
        self.framestack[len(self.framestack) - 1].destroy()
        self.framestack.pop()

    def destroy_all(self):
        """
        destroy all pages except the first aka. go back to start
        :return:
        """
        while len(self.framestack) > 1:
            self.destroy_top()

    def go_action(self, actions):
        """
        execute the action script
        :param actions:
        :return:
        """
        # hide the menu and show a delay screen
        self.hide_top()
        delay = Frame(self, bg="#2d89ef")
        delay.pack(fill=TkC.BOTH, expand=1)
        label = Label(delay, text="Executing...", fg="white", bg="#2d89ef", font="Sans 30")
        label.pack(fill=TkC.BOTH, expand=1)
        self.parent.update()

        # excute shell script
        subprocess.call([self.path + '/pimenu.sh'] + actions)
		
        # remove delay screen and show menu again
        delay.destroy()
        self.destroy_all()
        self.show_top()
	quit()
    def go_back(self):
        """
        destroy the current frame and reshow the one below, except when the config has changed
        then reinitialize everything
        :return:
        """
        if self.has_config_changed():
            self.initialize()
        else:
            self.destroy_top()
            self.show_top()


def main():
    root = Tk()
    root.geometry("320x240")
    root.wm_title('PiMenu')
    
    if len(sys.argv) > 2 and sys.argv[2] == 'fs':
        root.wm_attributes('-fullscreen', True)
    
    btn_frame = Frame(root, bg="#002AFF")
    img = PhotoImage(file=os.path.dirname(os.path.dirname(os.path.realpath(sys.argv[0]))) + "/icons/proglogo.png")
    pi_apps_btn = FlatButton(btn_frame,text=sys.argv[1], image=img, command=pi_apps_mainpage )
    pi_apps_btn.set_color("#002AFF")
    pi_apps_btn.pack()
    piframe = Frame(root, bg="#155CAA")
    btn_frame.pack(padx=1,pady=1, fill=TkC.BOTH)
    piframe.pack(fill=TkC.BOTH, expand=1)
    PiMenu(piframe)
    root.mainloop()

if __name__ == '__main__':
    main()
