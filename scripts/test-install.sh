#!/bin/bash
set -euo pipefail

# Run on macOS with Kitty and Fastfetch available.
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
test_dir=$(mktemp -d)
trap 'rm -rf -- "$test_dir"' EXIT
export HOME="$test_dir/home"
export XDG_CONFIG_HOME="$test_dir/config"

mkdir -p "$HOME/Library/Fonts" "$XDG_CONFIG_HOME/kitty"
touch "$HOME/Library/Fonts/JetBrainsMonoNerdFont-Regular.ttf"
printf 'original\n' > "$XDG_CONFIG_HOME/kitty/kitty.conf"

"$root/scripts/install.sh" --dry-run
[[ $(cat "$XDG_CONFIG_HOME/kitty/kitty.conf") == original ]]
[[ ! -e "$XDG_CONFIG_HOME/fastfetch" ]]
[[ -z $(find "$HOME" -name '.macos-dotfiles-backup.*' -print) ]]

"$root/scripts/install.sh"
cmp "$root/configs/kitty/kitty.conf" "$XDG_CONFIG_HOME/kitty/kitty.conf"
cmp "$root/configs/kitty/current-theme.conf" "$XDG_CONFIG_HOME/kitty/current-theme.conf"
cmp "$root/configs/fastfetch/config.jsonc" "$XDG_CONFIG_HOME/fastfetch/config.jsonc"
backups=("$HOME"/.macos-dotfiles-backup.*)
[[ ${#backups[@]} == 1 && $(cat "${backups[0]}/kitty/kitty.conf") == original ]]

"$root/scripts/install.sh"
backups=("$HOME"/.macos-dotfiles-backup.*)
[[ ${#backups[@]} == 1 ]]
printf 'Installer smoke test passed.\n'
