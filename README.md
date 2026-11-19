# Bliss on macOS

## Introduction

Windows XP nostalgia meets Liquid Glass. Bliss sets the scene, with navy windows, lime accents, and just enough transparency to let the hillside show through. The palette carries from Kitty's tab bar to the editor, browser chrome, and Obsidian.

## Setup

| Component | Setup |
| --- | --- |
| OS | macOS 27.0.1 on Apple silicon |
| Desktop / window management | Native macOS desktop and Liquid Glass; Rectangle configured for window snapping |
| Terminal | Kitty, with native rounded Powerline tabs and split panes |
| Shell | Zsh, Oh My Zsh, and the bundled `robbyrussell` prompt |
| Font | Menlo Regular at 22 pt in Kitty; JetBrains Mono Nerd Font at editor font size 20 in VS Code |
| Theme | Bliss palette in Kitty and VS Code; Cave Daisy CSS in Firefox; Kitty Navy in Obsidian |
| Editor | VS Code Dark+ with workbench and syntax overrides, plus Vibrancy Continued |
| Browser | Firefox with Lagoon, custom chrome and page CSS, and Dark Reader |
| Notes | Obsidian in dark mode with the Kitty Navy theme and Kitty Transparency plugin |
| Wallpaper | *Bliss* by Charles O’Rear |
| Other tools | Fastfetch and Homebrew |

## Features

- Navy surfaces (`#0c1830`) with lime highlights (`#a9df5a`), sky-blue accents (`#78b9ff`), and cool white text (`#e2eeff`).
- Kitty's top tab bar and split layout provide the multiplexer look through Kitty itself.
- Kitty, VS Code, Firefox, and Obsidian each use their own transparency settings. The shared navy tint is anchored at 80% where configured.
- Fastfetch uses the built-in macOS logo in Bliss colors and a generic title.

## Installation

With [Homebrew](https://brew.sh/) installed, run from the repository root:

```sh
brew bundle --file Brewfile
./scripts/install.sh --dry-run
./scripts/install.sh
```

The default installation applies Kitty and Fastfetch settings. Add `--vscode` to merge the appearance settings into VS Code’s default profile and install its tab CSS. Both modes back up existing files before replacing them. Restart Kitty and run `fastfetch`. The [app-by-app guide](docs/customization.md) covers Vibrancy activation and the manual steps for Zsh, Firefox, Obsidian, and the desktop. See [dependencies](docs/dependencies.md) for versions and optional components.

## Configuration

| Component | Files |
| --- | --- |
| Kitty | [Settings and keybindings](configs/kitty/kitty.conf) · [Bliss palette](configs/kitty/current-theme.conf) |
| Fastfetch | [Logo, colors, and modules](configs/fastfetch/config.jsonc) |
| Zsh | [Oh My Zsh and tab titles](configs/zsh/appearance.zsh) |
| VS Code | [Appearance settings](configs/vscode/settings.json) · [Tab CSS](configs/vscode/vibrancy-tabs.css) · [Extension ID](configs/vscode/extensions.txt) |
| Firefox | [Preferences](configs/firefox/user.js) · [Browser chrome](configs/firefox/userChrome.css) · [Page styles](configs/firefox/userContent.css) · [Dark Reader preset](configs/firefox/dark-reader-preset.json) |
| Obsidian | [Appearance](configs/obsidian/appearance.json) · [Kitty Navy](configs/obsidian/themes/Kitty%20Navy) · [Kitty Transparency](configs/obsidian/plugins/kitty-transparency) |

## Credits

- Charles O’Rear photographed *Bliss*, which Microsoft later chose as the default Windows XP wallpaper. Microsoft provides a downloadable Teams adaptation. [Microsoft's Bliss story and download](https://www.microsoft.com/en-us/copilot/blog/2021/07/08/get-nostalgic-with-new-microsoft-teams-backgrounds/)
- JetBrains designed JetBrains Mono. The Nerd Fonts project provides the patched family. [JetBrains Mono](https://www.jetbrains.com/lp/mono/) · [Nerd Fonts](https://www.nerdfonts.com/)
- Kovid Goyal created Kitty. Fastfetch is maintained by the Fastfetch project. Robby Russell created Oh My Zsh and its bundled prompt. [Kitty](https://sw.kovidgoyal.net/kitty/) · [Fastfetch](https://github.com/fastfetch-cli/fastfetch) · [Oh My Zsh](https://ohmyz.sh/)
- Microsoft provides VS Code and Dark+. Illixion maintains Vibrancy Continued. [VS Code](https://code.visualstudio.com/) · [Vibrancy Continued](https://github.com/illixion/vscode-vibrancy-continued)
- Firefox supplies Lagoon through its theme system. Dark Reader is maintained by the Dark Reader project. Ryan Hanson maintains Rectangle. [Firefox](https://www.firefox.com/) · [Dark Reader](https://darkreader.org/) · [Rectangle](https://rectangleapp.com/)
- Bliss terminal colors, Cave Daisy CSS, Kitty Navy, and Kitty Transparency are the local customizations collected here.

## License

The repository's custom configurations, code, and documentation are available under the [MIT License](LICENSE). Third-party apps, fonts, extensions, themes and the wallpaper retain their own terms. The repository includes only links for the wallpaper.
