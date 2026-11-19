#!/bin/bash
set -euo pipefail

# Run on macOS with Kitty and Fastfetch available.
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
test_dir=$(mktemp -d)
trap 'rm -rf -- "$test_dir"' EXIT
export HOME="$test_dir/home"
export XDG_CONFIG_HOME="$test_dir/config"

mkdir -p "$HOME" "$XDG_CONFIG_HOME/kitty"
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
settings="$HOME/Library/Application Support/Code/User/settings.json"
mkdir -p "$(dirname -- "$settings")"
printf '%s\n' '{"editor.wordWrap":"on","vscode_vibrancy.imports":["custom.css"]}' > "$settings"
"$root/scripts/install.sh" --vscode --dry-run
[[ ! -e "$HOME/.vscode/vibrancy-tabs.css" ]]
"$root/scripts/install.sh" --vscode
cmp "$root/configs/vscode/vibrancy-tabs.css" "$HOME/.vscode/vibrancy-tabs.css"
python3 - "$settings" "$HOME/.vscode/vibrancy-tabs.css" <<'PYTHON'
import json
from pathlib import Path
import sys

settings = json.loads(Path(sys.argv[1]).read_text())
assert settings["editor.wordWrap"] == "on"
assert settings["workbench.colorTheme"] == "Dark+"
assert settings["vscode_vibrancy.imports"] == ["custom.css", sys.argv[2]]
PYTHON
"$root/scripts/install.sh" --vscode
backups=("$HOME"/.macos-dotfiles-backup.*)
[[ ${#backups[@]} == 2 ]]
printf '%s\n' '{ // keep this comment' '}' > "$settings"
if "$root/scripts/install.sh" --vscode; then exit 1; fi
[[ $(cat "$settings") == $'{ // keep this comment\n}' ]]
printf 'Installer smoke test passed.\n'
