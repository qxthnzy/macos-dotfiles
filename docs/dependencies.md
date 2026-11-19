# Dependencies

The [Brewfile](../Brewfile) covers the apps used in the setup. The [installer](../scripts/install.sh) needs Kitty and Fastfetch for its default mode. Menlo ships with macOS. The optional `--vscode` mode also requires Python 3. JetBrains Mono Nerd Font remains part of the editor and browser setup.

| Component | Observed version or source |
| --- | --- |
| macOS | 27.0.1, arm64 |
| Kitty | 0.48.2 |
| Fastfetch | 2.69.0 |
| JetBrains Mono Nerd Font | Homebrew's `font-jetbrains-mono-nerd-font` cask |
| Zsh | macOS shell with Oh My Zsh and its bundled `git` plugin |
| VS Code | 1.147.0 and Vibrancy Continued 1.6.0 |
| Firefox | 160.0.1, Lagoon 1.1, and Dark Reader 4.9.135 |
| Obsidian | 1.12.7, local Kitty Navy and Kitty Transparency 1.0.0 |
| Rectangle | 0.95 |

Versions document the source machine. Homebrew installs the currently available versions. Browser styles and Electron transparency are the most version-sensitive parts of the setup. The terminal tabs and panes are native Kitty features and require no multiplexer.

Run `./scripts/test-install.sh` to verify dry-run, backup creation and repeated installation with a temporary home and config directory.
