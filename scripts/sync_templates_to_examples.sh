#!/bin/bash

set -euo pipefail

# Maintains the adr-guidelines repository by synchronizing all files from
# the templates/ directory into the examples/ directory.
#
# Each generated file is prefixed with a header indicating that it was
# generated from a template and must not be edited directly.
#
# For bash scripts, the generated header is inserted starting at line 2
# (after the shebang if present) and uses "#" comments to keep the script
# executable.
#
# The script overwrites the destination files, so re-running it does not
# stack headers (i.e. it is idempotent for the generated output).


TEMPLATES_DIR="templates"
EXAMPLES_DIR="examples"

HEADER_HTML='<!-- This file is generated from templates/%s -->
<!-- Do not edit directly; update the template instead -->

'

HEADER_BASH='# This file is generated from templates/%s
# Do not edit directly; update the template instead

'

# Only sync known text/template artifacts
# (avoids corrupting binaries if they are ever added)
ALLOWED_EXT_RE='\.(md|sh)$'
ALLOWED_BASENAMES_RE='^(README\.md|CODEOWNERS)$'

# Ensure examples directory exists
mkdir -p "$EXAMPLES_DIR"

is_allowed_file() {
  local path="$1"
  local base
  base="$(basename "$path")"

  if [[ "$base" =~ $ALLOWED_BASENAMES_RE ]]; then
    return 0
  fi
  if [[ "$path" =~ $ALLOWED_EXT_RE ]]; then
    return 0
  fi
  return 1
}

is_bash_script() {
  local path="$1"

  # Treat *.sh as bash scripts
  if [[ "$path" == *.sh ]]; then
    return 0
  fi

  # Also treat any file with a sh/bash shebang as a bash script
  if head -n 1 "$path" | grep -qE '^#!.*/(ba)?sh'; then
    return 0
  fi

  return 1
}

copy_file() {
  local src="$1"
  local dest="$2"
  local rel_path="$3"

  mkdir -p "$(dirname "$dest")"

  local tmp
  tmp="$(mktemp)"

  if is_bash_script "$src"; then
    local first
    first="$(head -n 1 "$src" || true)"

    if [[ "$first" == \#!* ]]; then
      # Preserve shebang on line 1 and insert header starting at line 2
      printf '%s\n' "$first" > "$tmp"
      printf "$HEADER_BASH" "$rel_path" >> "$tmp"
      tail -n +2 "$src" >> "$tmp"
    else
      # No shebang: prepend header then full content
      printf "$HEADER_BASH" "$rel_path" > "$tmp"
      cat "$src" >> "$tmp"
    fi
  else
    # Non-bash: use HTML comment header at top
    printf "$HEADER_HTML" "$rel_path" > "$tmp"
    cat "$src" >> "$tmp"
  fi

  mv "$tmp" "$dest"

  # Preserve file mode (incl. executable bit)
  # GNU: chmod --reference=...
  # macOS/BSD: no --reference; fall back to preserving just executability
  if chmod --reference="$src" "$dest" 2>/dev/null; then
    :
  elif command -v gchmod >/dev/null 2>&1 && gchmod --reference="$src" "$dest" 2>/dev/null then
       :
  else
    if [[ -x "$src" ]]; then
      chmod +x "$dest"
    else
      chmod -x "$dest" 2>/dev/null || true
    fi
  fi
}

# Copy files from templates to examples
# Use -print0 to safely handle spaces
find "$TEMPLATES_DIR" -type f -print0 | while IFS= read -r -d '' src; do
  is_allowed_file "$src" || continue

  rel_path="${src#$TEMPLATES_DIR/}"

  # Normalize script name in examples/ (preferred name)
  if [[ "$rel_path" == "scripts/generated_adr_index.sh" ]]; then
    rel_path="scripts/generate_adr_index.sh"
  fi

  dest="$EXAMPLES_DIR/$rel_path"
  copy_file "$src" "$dest" "$rel_path"
done

echo "Templates successfully synced to examples/"
