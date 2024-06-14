# Changelog

## (In Development)

- Add changelog to repo root and to built plugin bundle.


## Version 0.5.3 (2024-06-14)

This release includes updated versions of the pcre2 (v10.44) and editorconfig-core-c (v0.12.8) tools that do the actual parsing of `.editorconfig` files. It fixes a memory leak and improves support for newer versions of Unicode.


## Version 0.5.2 (2024-03-31)

This updates the underlying editorconfig-core-c library that does the actual parsing of `.editorconfig` files, which fixes some memory and possible security issues. For details, see: https://github.com/editorconfig/editorconfig-core-c/releases/tag/v0.12.7


## Version 0.5.1 (2023-01-19)

This release updates the core EditorConfig parser ([EditorConfig Core C](https://github.com/editorconfig/editorconfig-core-c)) to v0.12.6, which addresses security vulnerability [CVE-2023-0341](https://github.com/advisories/GHSA-f352-cwm8-5w9w). It also supports longer property names and values in your `.editorconfig` files.


## Version 0.5.0 (2022-11-04)

Version 0.5.0 adds support for Apple processors in addition to Intel (see [#41](https://github.com/Mr0grog/editorconfig-textmate/issues/41)), and requires MacOS 11.0 (Big Sur) or later.


## Version 0.5.0-alpha2 (2022-11-03)

There shouldn't be much different from a user perspective between Alpha 1 and this (the only real feature is Apple Silicon support), but the internals are cleaned up a fair bit and is more-or-less ready to ship.


## Version 0.5.0-alpha1 (2021-11-06)

This release adds support for Apple silicon! You should be able to use this bundle equally well on Intel and Apple processors. This is still a work in progress (see [#44](https://github.com/Mr0grog/editorconfig-textmate/pull/44)), so please comment via that PR or file new issues if you encounter problems.


## Version 0.4.1 (2021-11-06)

This release fixes a crash when using some .net-specific properties for Visual Studio projects. ([#42](https://github.com/Mr0grog/editorconfig-textmate/issues/42))


## Version 0.4.1-alpha1 (2021-10-31)

This release updates editorconfig-core to v0.12.5, and fixes some crashes.


## Version 0.4.0 (2019-11-11)

Version 0.4.0 fixes compatibility with TextMate 2.0.3+ (Note that TextMate 2.0 final through TextMate 2.0.2 do not work with any plugins at all.)

It also updates the core EditorConfig parsing library to support more complex file matching expressions.


## Version 0.4.0-beta1 (2019-11-10)

This is a test release for v0.4.0, which makes the plugin compatible with TextMate 2.0.3+ and updates the underlying EditorConfig parsing library.


## Version 0.3.1 (2017-05-06)

Fixes a terrible bug where the `max_line_length` setting would affect indent size instead of the actual line wrapping.


## Version 0.3.0 (2017-01-20)

Finally adds support for all standard EditorConfig options:
- root
- indent_style ("tab" or "space")
- indent_size
- tab_width
- insert_final_newline (newline is added when saving a document)
- trim_trailing_whitespace (whitespace is trimmed when saving a document)
- end_of_line
- charset (the charset `utf-8-bom` is not supported; if you need it, please [file an issue](https://github.com/Mr0grog/editorconfig-textmate/issues).)

Starting with this release, EditorConfig-TextMate only supports TextMate 2 and later.


## Version 0.3.0-alpha (2017-01-06)

(Finally) adds support for `trim_trailing_whitespace` and `insert_final_newline`.

NOTE: when trimming trailing whitespace, column selections (as opposed to normal, ranged selections that start at one character and end at another) may be transformed into ranged selections. I can’t find a reasonable way to get around this right now, though I am hoping for feedback from the TextMate developers.

If this causes problems for you _please_ post an issue about it. I’m assuming it’s an OK caveat, but am happy to make changes if other people disagree.


## Version 0.2.6 (2016-11-17)

Fixes an issue with TextMate2 RC1 ([#24](https://github.com/Mr0grog/editorconfig-textmate/issues/24))


## Version 0.2.6-beta (2016-11-17)

Hotfix for an error in the latest release of TextMate 2. For details, see [#24](https://github.com/Mr0grog/editorconfig-textmate/issues/24).


## Version 0.2.5 (2016-05-26)

Updates EditorConfig Core to v0.12.1 and PCRE to 8.38.


## Version 0.2.4 (2014-11-24)

Upgrading the EditorConfig Core library to v0.12.0, which adds support some new kinds of file matching patterns. See more at the EditorConfig-Core project page: https://github.com/editorconfig/editorconfig-core-c


## Version 0.2.4-alpha (2013-12-12)

Updates the underlying EditorConfig-Core library to improve stability.


## Version 0.2.3 (2013-10-11)

Compatibility updates for TM2 Alpha. Fix TM2 Alpha again. Now works with build 9487.


## Version 0.2.3-alpha (2013-10-06)

This fixes broken-ness in TextMate2 alpha again.
