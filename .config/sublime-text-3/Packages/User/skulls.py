import sublime, sublime_plugin

class ExampleCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        self.view.insert(edit, 0, "Hello, World!")


class Skull(dict):
    def __init__(self, state):
        self['mode'] = "Foo"
