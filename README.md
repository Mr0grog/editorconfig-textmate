EditorConfig—TextMate PlugIn
============================

This is a TextMate plug-in that provides support for [Editor Config](http://editorconfig.org/). It will cause TextMate to set its editing features (e.g. tab style and size) according to a `.editorconfig` file you include alongside your source code.

Download it now at: https://github.com/downloads/Mr0grog/editorconfig-textmate/editorconfig-textmate-0.1.tar.gz

*Note: this plug-in does not support TextMate 2. See below for details.*


Feature Support
---------------

The following Editor Config features are supported:

- root
- indent_style ("tab" or "space")
- indent_size
- tab_width

The `end_of_line` feature is not yet supported. Neither are upcoming features like `charset`, `trim_trailing_whitespace`, and `insert_final_newline`.


Installation
------------

You can download a precompiled binary from GitHub's downloads page:

https://github.com/Mr0grog/editorconfig-textmate/downloads

Just un-tar it and double-click the `editorconfig-textmate.tmplugin` file to install.


To-Do
-----

Currently, [editorconfig-core](https://github.com/editorconfig/editorconfig-core) is included as a precompiled binary, but it really should be included as a submodule, with an appropriate build target in Xcode.

Support for `end_of_line` is also needed, but I have to figure out exactly how to do it in TextMate first :P


TextMate 2
----------

Unfortunately, this plug-in probably won't be coming to TextMate 2 any time in the near future. There are a few issues: 

- TM2 will only load plug-ins from Macromates (this is easy to work around, but is a clear sign you're doing something not-so-good).
- As of July 25, 2012, the (soft)tab and tab size settings in TM2 are actually hardcoded. You can modify them, but as soon as you close and re-open the file, you're back to the defaults. It's been this way for 6 months; I'm not sure it's changing any time soon.
