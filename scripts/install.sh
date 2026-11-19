#!/bin/bash
set -euo pipefail

die() { printf 'Error: %s\n' "$*" >&2; exit 1; }

[[ $(uname -s) == Darwin ]] || die 'This installer requires macOS.'

dry_run=false
case "${1:-}" in
  --dry-run) dry_run=true ;;
  --help|-h) printf 'Usage: %s [--dry-run]\n' "$0"; exit 0 ;;
  '') ;;
  *) die 'Usage: scripts/install.sh [--dry-run]' ;;
esac
[[ $# -le 1 ]] || die 'Pass at most one option.'

root=$(cd -- "$(dirname -- "$0")/.." && pwd)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
[[ $config_home == /* ]] || die 'XDG_CONFIG_HOME must be an absolute path.'
files=(kitty/kitty.conf kitty/current-theme.conf fastfetch/config.jsonc)
missing=()
command -v fastfetch >/dev/null 2>&1 || missing+=(Fastfetch)
if ! command -v kitty >/dev/null 2>&1 &&
   [[ ! -x /Applications/kitty.app/Contents/MacOS/kitty &&
      ! -x "$HOME/Applications/kitty.app/Contents/MacOS/kitty" ]]; then
  missing+=(Kitty)
fi
# shortcut: checks standard font locations for the packaged Regular face, extend for custom font locations.
font_found=false
for font_dir in "$HOME/Library/Fonts" /Library/Fonts; do
  if [[ -f "$font_dir/JetBrainsMonoNerdFont-Regular.ttf" ||
        -f "$font_dir/JetBrainsMonoNerdFont-Regular.otf" ]]; then
    font_found=true
    break
  fi
done
$font_found || missing+=('JetBrains Mono Nerd Font')
if (( ${#missing[@]} > 0 )); then
  printf 'Missing dependencies: %s. Run brew bundle --file "%s/Brewfile".\n' "${missing[*]}" "$root" >&2
  $dry_run || exit 1
fi

changed=()
for file in "${files[@]}"; do
  src="$root/configs/$file"
  dest="$config_home/$file"
  [[ -f $src && -r $src ]] || die "Cannot read $src"
  parent=$(dirname -- "$dest")
  while [[ $parent != / ]]; do
    # macOS presents several standard directories through /private.
    case "$parent" in
      /tmp|/var|/etc) break ;;
    esac
    [[ ! -L $parent && ( ! -e $parent || -d $parent ) ]] ||
      die "Expected a directory without symlinks at $parent"
    parent=$(dirname -- "$parent")
  done
  [[ ! -L $dest && ( ! -e $dest || -f $dest ) ]] ||
    die "Expected a regular file or an unused path at $dest"
  if [[ -f $dest ]] && cmp -s -- "$src" "$dest"; then
    printf 'Already current: %s\n' "$dest"
    continue
  fi
  changed+=("$file")
  printf 'Install %s%s\n' "$dest" "$(if [[ -f $dest ]]; then printf ' (back up existing file first)'; fi)"
done

if $dry_run; then exit 0; fi
if (( ${#changed[@]} == 0 )); then exit 0; fi

umask 077
backup=
for file in "${changed[@]}"; do
  dest="$config_home/$file"
  if [[ -f $dest ]]; then
    if [[ -z $backup ]]; then
      backup=$(mktemp -d "$HOME/.macos-dotfiles-backup.XXXXXXXX") ||
        die 'Cannot create a backup directory.'
      printf 'Backups: %s\n' "$backup"
    fi
    mkdir -p -- "$backup/$(dirname -- "$file")" || die "Cannot prepare backup for $dest"
    cp -p -- "$dest" "$backup/$file" || die "Cannot back up $dest"
  fi
done

temp=
trap 'if [[ -n $temp ]]; then rm -f -- "$temp"; fi' EXIT
for file in "${changed[@]}"; do
  dest="$config_home/$file"
  mkdir -p -- "$(dirname -- "$dest")" || die "Cannot prepare directory for $dest"
  temp=$(mktemp "${dest}.install.XXXXXXXX") || die "Cannot stage $dest"
  cp -- "$root/configs/$file" "$temp" || die "Cannot stage $dest"
  mv -f -- "$temp" "$dest" || die "Cannot install $dest"
  temp=
done
printf 'Restart Kitty and run fastfetch. See docs/customization.md for the other apps.\n'
