# Customization

## macOS and Rectangle

In System Settings → Appearance, choose **Dark**. In Accessibility → Display, leave **Reduce transparency** off for the glass effects. Under Desktop & Dock, place the Dock on the left, enable magnification and auto-hide, and set the size to taste (the observed Dock preference was 46). The observed macOS edge-tiling shortcuts and margins were disabled. In Rectangle, use the alternate default shortcuts and a zero window gap. Grant Accessibility access if macOS prompts you.

In System Settings → Wallpaper, select your own copy of the image. The active JPEG was a 4800 × 3000 image in Downloads with iLoveIMG processing metadata. The earlier download source is unknown. Microsoft offers a [Teams adaptation of Bliss](https://www.microsoft.com/en-us/copilot/blog/2021/07/08/get-nostalgic-with-new-microsoft-teams-backgrounds/) for personal use under Microsoft's terms.

## Kitty, Fastfetch, and Zsh

Kitty includes `current-theme.conf`. The active tab and border use lime green, the inactive tab uses muted blue, and window opacity is `0.8`. `Cmd+Shift+T` opens a tab. `Cmd+Shift+D` and `Cmd+Shift+E` split the current tab. The installer uses `XDG_CONFIG_HOME` when set, otherwise `~/.config`.

Run `fastfetch` when you want the system overview. Add it to your own shell startup if you want it to run automatically. The exported config displays `Bliss` as the header and omits the local IP module. Review the other hardware and system details before sharing terminal output.

Install [Oh My Zsh](https://ohmyz.sh/) if needed. Copy [appearance.zsh](../configs/zsh/appearance.zsh) to `~/.config/zsh/appearance.zsh` and replace your existing Oh My Zsh initialization in `~/.zshrc` with `source "$HOME/.config/zsh/appearance.zsh"`, or merge its settings into your initialization. It contains the `robbyrussell` theme, `git` plugin, and directory-based window title hook. Keep your existing aliases and shell integration.

## VS Code

1. Open **Preferences: Open User Settings (JSON)**. Merge [the settings](../configs/vscode/settings.json) into the active user profile. Merge nested color maps as needed.
2. Install **Vibrancy Continued** (`illixion.vscode-vibrancy-continued`) from the Extensions tab for window transparency. The built-in Dark+ theme provides the base syntax styling. The default file and product icons require no extension.
3. Copy [vibrancy-tabs.css](../configs/vscode/vibrancy-tabs.css) to `~/.vscode/vibrancy-tabs.css`. Add the full local path to that file to the `vscode_vibrancy.imports` array in your user settings. The extension reads the path literally.
4. Run **Reload Vibrancy** from the Command Palette and restart as prompted. The extension patches the application to enable the native window effect. Use **Disable Vibrancy** and restart to revert the patch. After an editor update, the extension may need to apply the patch again.

## Firefox

1. Open `about:profiles` and use **Open in Finder** under the active profile's **Root Directory**. Quit Firefox before editing files.
2. Back up any existing `chrome/userChrome.css`, `chrome/userContent.css`, and `user.js`. Create `chrome/` if needed. Copy or merge the matching files from [the Firefox configuration](../configs/firefox/). Place `user.js` at the profile root.
3. Restart Firefox. Select **Lagoon** under Add-ons and Themes if offered by your Firefox build. The active theme ID in the source profile was `nova-lagoon@mozilla.org`. The CSS supplies the navy styling and lime active-tab accent.
4. For broad website recoloring, install [Dark Reader](https://addons.mozilla.org/firefox/addon/darkreader/). The bundled JSON is a saved local preset. Import it via Dark Reader's settings if your version supports it, after exporting your current settings. The saved preset uses the Dynamic engine and a darker base tint than the browser chrome. Its exact correspondence to the live extension settings was unverified.
5. To undo the changes, quit Firefox and restore your former files. Values written by `user.js` persist after removing the file. Reset the modified preferences through `about:config` if needed.

`userContent.css` applies global page rules as well as site-specific palettes. Site updates can require selector changes. Remove or temporarily rename that file if you want the browser chrome styles without the page overrides.

## Obsidian

1. Close Obsidian. In the vault of your choice, back up any affected files. Copy `themes/Kitty Navy/` from [the Obsidian configuration](../configs/obsidian/) to the vault's `.obsidian/themes/` directory, or use the vault's custom config folder.
2. In **Settings → Appearance**, choose Dark and Kitty Navy, set the accent to `#a9df5a`, and leave built-in translucency off. The [appearance JSON](../configs/obsidian/appearance.json) is a reference for these values.
3. For the crisp see-through window effect, review the [local plugin](../configs/obsidian/plugins/kitty-transparency/) and copy its directory to the vault's config `plugins/`. Start Obsidian, allow community plugins, enable **Kitty Transparency**, then restart. The CSS uses `body.kn-transparent` from the plugin and an 80% navy background. The plugin uses Obsidian's desktop Electron window handle, which can change between app versions.
4. To revert, disable the plugin, select your previous theme, and restart Obsidian.
