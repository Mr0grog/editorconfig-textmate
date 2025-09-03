#  Contributing/Development

If you encounter issues or are interested in seeing new features added, please file an issue: https://github.com/Mr0grog/editorconfig-textmate/issues

If you think you know how to fix the issue, feel free to create a pull request!


## Release Process

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
    $ xcrun notarytool submit editorconfig-textmate.tmplugin.zip \
        --apple-id "$NOTARIZE_USERNAME" \
        --password "$NOTARIZE_PASSWORD" \
        --team-id "$NOTARIZE_TEAM" \
        --wait
    # Should result in something like:
    # Conducting pre-submission checks for editorconfig-textmate.tmplugin.zip and initiating connection to the Apple notary service...
    # Submission ID received
    #   id: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    # Successfully uploaded file
    #   id: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    #   path: /path/to/editorconfig-texmate.tmplugin.zip
    # Waiting for processing to complete.
    # Current status: Accepted........
    # Processing complete
    #   id: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    #   status: Accepted
    ```
    
    NOTE: you’ll need to have an app-specific password for the AppleID account you are notarizing with. You can set one up on the AppleID profile page. You’ll also need to know your WWDRTeamID, which you can get by running `xcrun altool --list-providers`.
    
    The above command also assumes you have some environment variables with the appropriate values.

5. The above command should keep running until notarization is complete. If it times out, though, you can also poll for the status on the command line:

    ```sh
    $ xcrun notarytool history \
        --apple-id "$NOTARIZE_USERNAME" \
        --password "$NOTARIZE_PASSWORD" \
        --team-id "$NOTARIZE_TEAM"
    # Successfully received submission history.
    #  history
    #     --------------------------------------------------
    #     createdDate: 2021-11-01T03:02:21.177Z
    #     id: f868dd45-7c71-4f48-a678-8fa1d1718d2d
    #     name: editorconfig-textmate.tmplugin.zip
    #     status: Accepted
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
