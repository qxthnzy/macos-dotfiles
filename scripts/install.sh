#!/bin/bash
set -euo pipefail

die() { printf 'Error: %s\n' "$*" >&2; exit 1; }

[[ $(uname -s) == Darwin ]] || die 'This installer requires macOS.'

dry_run=false
install_vscode=false
for option in "$@"; do
  case "$option" in
    --dry-run) dry_run=true ;;
    --vscode) install_vscode=true ;;
    --help|-h) printf 'Usage: %s [--dry-run] [--vscode]\n' "$0"; exit 0 ;;
    *) die 'Usage: scripts/install.sh [--dry-run] [--vscode]' ;;
  esac
done

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
if $install_vscode; then
  command -v python3 >/dev/null 2>&1 || missing+=(Python3)
  files+=(vscode/vibrancy-tabs.css vscode/settings.json)
fi
if (( ${#missing[@]} > 0 )); then
  printf 'Missing dependencies: %s. See "%s/docs/dependencies.md".\n' "${missing[*]}" "$root" >&2
  $dry_run || exit 1
fi

destination() {
  case "$1" in
    vscode/vibrancy-tabs.css) printf '%s\n' "$HOME/.vscode/vibrancy-tabs.css" ;;
    vscode/settings.json) printf '%s\n' "$HOME/Library/Application Support/Code/User/settings.json" ;;
    *) printf '%s\n' "$config_home/$1" ;;
  esac
}

changed=()
for file in "${files[@]}"; do
  src="$root/configs/$file"
  dest=$(destination "$file")
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
  if [[ $file == vscode/settings.json ]]; then
    settings=$(python3 "$root/scripts/merge-vscode.py" "$src" "$dest" "$(destination vscode/vibrancy-tabs.css)") ||
      die 'Could not merge VS Code settings. See docs/customization.md.'
    if [[ -f $dest ]] && cmp -s -- <(printf '%s\n' "$settings") "$dest"; then
      printf 'Already current: %s\n' "$dest"
      continue
    fi
  elif [[ -f $dest ]] && cmp -s -- "$src" "$dest"; then
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
  dest=$(destination "$file")
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
  dest=$(destination "$file")
  mkdir -p -- "$(dirname -- "$dest")" || die "Cannot prepare directory for $dest"
  temp=$(mktemp "${dest}.install.XXXXXXXX") || die "Cannot stage $dest"
  if [[ $file == vscode/settings.json ]]; then
    printf '%s\n' "$settings" > "$temp" || die "Cannot stage $dest"
  else
    cp -- "$root/configs/$file" "$temp" || die "Cannot stage $dest"
  fi
  mv -f -- "$temp" "$dest" || die "Cannot install $dest"
  temp=
done
printf 'Restart Kitty and run fastfetch. See docs/customization.md for the other apps.\n'
