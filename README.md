EditorConfig—TextMate PlugIn
============================

This is a TextMate plug-in that provides support for [EditorConfig](http://editorconfig.org/). It will cause TextMate to set its editing features (e.g. tab style and size) according to a `.editorconfig` file you include alongside your source code.

Download it now at: https://github.com/Mr0grog/editorconfig-textmate/releases/latest

EditorConfig-TextMate only supports TextMate 2 (see below for information about TextMate 1) on MacOS 11.0 or later. It works with both Intel and Apple processors.


Feature Support
---------------

The following Editor Config features are supported:

- root
- indent_style ("tab" or "space")
- indent_size
- tab_width
- insert_final_newline (newline is added when saving a document)
- trim_trailing_whitespace (whitespace is trimmed when saving a document)
- end_of_line
- charset (the charset `utf-8-bom` is not supported; if you need it, please [file an issue](https://github.com/Mr0grog/editorconfig-textmate/issues).)
- max_line_length (sets TextMate’s “wrap column,” but does not necessarily trigger hard line wraps)


Installation
------------

You can download a precompiled binary from:

https://github.com/Mr0grog/editorconfig-textmate/releases/latest

Unzip it and double-click the `editorconfig-textmate.tmplugin` file to install. You can also manually drag the `.tmplugin` bundle into `~/Library/Application Support/TextMate/PlugIns/` in Finder.

**Note:** the plug-in will be loaded automatically after restarting TextMate.
It will not be listed in the bundles list, since bundles and plug-ins are different things in TextMate.


Issues
------

If you encounter issues or are interested in seeing new features added, please file an issue: https://github.com/Mr0grog/editorconfig-textmate/issues

I am also happy to take pull requests! For more information about contributing and development, see [`CONTRIBUTING.md`](./CONTRIBUTING.md).


TextMate 1
----------

The current version of this plugin only supports TextMate 2, but [version 0.2.6](https://github.com/Mr0grog/editorconfig-textmate/releases/tag/v0.2.6) and earlier support TextMate 1. That version only supports the following EditorConfig properties:

- root
- indent_style ("tab" or "space")
- indent_size
- tab_width

You can find older versions on the [releases page](https://github.com/Mr0grog/editorconfig-textmate/releases).


License
-------

This plug-in is open source. It is copyright (c) 2012-2024 Rob Brackett and licensed under the MIT license. The full license text is in the `LICENSE` file.
