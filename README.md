EditorConfig—TextMate PlugIn
============================

This is a TextMate plug-in that provides support for [EditorConfig](http://editorconfig.org/). It will cause TextMate to set its editing features (e.g. tab style and size) according to a `.editorconfig` file you include alongside your source code.

Download it now at: https://github.com/Mr0grog/editorconfig-textmate/releases/latest

Only some features are support in TextMate 1 (all features work in TextMate 2). TM1 support may be removed in the near future, though older builds that support it will continue to be downloadable.


Feature Support
---------------

The following Editor Config features are supported:

- root
- indent_style ("tab" or "space")
- indent_size
- tab_width
- insert_final_newline (newline is added when saving a document)
- trim_trailing_whitespace (whitespace is trimmed when saving a document)

The `end_of_line` and `charset` features are not yet supported (see #23 for tracking).


Installation
------------

You can download a precompiled binary from:

https://github.com/Mr0grog/editorconfig-textmate/releases/latest

Just un-tar it and double-click the `editorconfig-textmate.tmplugin` file to install. You can also drag the `.tmplugin` package into `~/Library/Application Support/TextMate/PlugIns/` in Finder.


Issues
------

If you encounter issues or are interested in seeing new features added, please file an issue: https://github.com/Mr0grog/editorconfig-textmate/issues

I am also happy to take pull requests :)


License
-------

This plug-in is open source. It is copyright (c) 2012-2017 Rob Brackett and licensed under the MIT license. The full license text is in the `LICENSE` file.
