EditorConfig—TextMate PlugIn
============================

This is a TextMate plug-in that provides support for [EditorConfig](http://editorconfig.org/). It will cause TextMate to set its editing features (e.g. tab style and size) according to a `.editorconfig` file you include alongside your source code.

Download it now at: https://github.com/Mr0grog/editorconfig-textmate/releases/latest

EditorConfig-TextMate only supports TextMate 2 (see below for information about TextMate 1).


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

Un-tar it and double-click the `editorconfig-textmate.tmplugin` file to install. You can also manually drag the `.tmplugin` package into `~/Library/Application Support/TextMate/PlugIns/` in Finder.

**Note:** the plug-in will be loaded automatically after restarting TextMate.
It will not be listed in the bundles list, since bundles and plug-ins are different things in TextMate.


Issues
------

If you encounter issues or are interested in seeing new features added, please file an issue: https://github.com/Mr0grog/editorconfig-textmate/issues

I am also happy to take pull requests :)


TextMate 1
----------

The current version of this plugin only supports TextMate 2, but [version 0.2.6](https://github.com/Mr0grog/editorconfig-textmate/releases/tag/v0.2.6) and earlier support TextMate 1. That version only supports the following EditorConfig properties:

- root
- indent_style ("tab" or "space")
- indent_size
- tab_width

You can find older versions on the [releases page](https://github.com/Mr0grog/editorconfig-textmate/releases).


Release Process
---------------

As of the final, non-beta TextMate 2.0 release, TextMate uses MacOS’s runtime hardening feature. That means any loaded bundles (like this plugin) must be properly signed. As of MacOS 10.15, they must also be notarized by Apple. Xcode is set up to automatically sign the bundle, but it will only automatically notarize *apps.* That means notarization is a manual process for this project.

You can find some general info about notarization at: https://developer.apple.com/documentation/xcode/notarizing_your_app_before_distribution

And much more detailed info about the manual notarization process at: https://developer.apple.com/documentation/xcode/notarizing_your_app_before_distribution/customizing_the_notarization_workflow

In practice, the process is:

1. Build a release bundle via the “archive” command in Xcode.

2. Use the organizer to export the bundle from the archive.

3. Open a command-line prompt wherever the bundle is and make a zip of it:

    ```sh
    $ ditto -c -k --keepParent editorconfig-textmate.tmplugin editorconfig-textmate.tmplugin.zip
    ```

4. Send the zip off to Apple for notarization:

    ```sh
    # This uploads the zip to Apple and might take a minute.
    $ xcrun altool \
        --notarize-app \
        --primary-bundle-id 'org.robbrackett.editorconfig-textmate' \
        --username $NOTARIZE_USERNAME \
        --password $NOTARIZE_PASSWORD \
        --asc-provider $NOTARIZE_PROVIDER_SHORTNAME \
        --file editorconfig-textmate.tmplugin.zip
    # Should result in something like:
    # No errors uploading 'editorconfig-textmate.tmplugin.zip'.
    # RequestUUID = xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    ```
    
    NOTE: you’ll need to have an app-specific password for the AppleID account you are notarizing with. You can set one up on the AppleID profile page.
    
    The above command also assumes you have some environment variables with the appropriate values.

5. Wait for an e-mail indicating that notarization is complete. You can also poll for the status on the command line:

    ```sh
    $ xcrun altool \
        --notarization-history 0 \
        --username $NOTARIZE_USERNAME \
        --password $NOTARIZE_PASSWORD
    # Should result in something like:
    # Notarization History - page 0
    #
    # Date                      RequestUUID                          Status  Status Code Status Message
    # ------------------------- ------------------------------------ ------- ----------- ----------------
    # 2019-11-12 01:04:43 +0000 xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx success 0           Package Approved
    #
    # Next page value: abcxyz
    ```
    
    For troubleshooting help here, see the [“Check the Status of Your Request”](https://developer.apple.com/documentation/xcode/notarizing_your_app_before_distribution/customizing_the_notarization_workflow?language=objc#3087732) section of Apple’s docs.

6. “Staple” the notarization to the bundle:

    ```sh
    # Note this runs against the actual bundle, NOT the zip
    # we uploaded when notarizing.
    $ xcrun stapler staple editorconfig-textmate.tmplugin
    ```

7. Finally, zip up the notarized & stapled bundle and upload that to GitHub releases. Whew!

You can verify the code signature with:

```sh
$ codesign --verify --deep --strict --verbose=2 editorconfig-textmate.tmplugin
# Results in:
# editorconfig-textmate.tmplugin: valid on disk
# editorconfig-textmate.tmplugin: satisfies its Designated Requirement
```

And then verify that it is properly notarized for GateKeeper with:

```sh
$ spctl -a -t install -vv editorconfig-textmate.tmplugin
# Results in:
# editorconfig-textmate.tmplugin: accepted
# source=Notarized Developer ID
# origin=Developer ID Application: Rob Brackett (ABCXYZ)
```


License
-------

This plug-in is open source. It is copyright (c) 2012-2019 Rob Brackett and licensed under the MIT license. The full license text is in the `LICENSE` file.
