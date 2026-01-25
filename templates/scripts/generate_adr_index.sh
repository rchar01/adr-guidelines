#!/bin/bash

set -euo pipefail

ADR_DIR="adr"
INDEX_FILE="ADR-INDEX.md"

# Allowed ADR statuses (single source of truth)
ALLOWED_STATUSES=(
  "Accepted"
  "Rejected"
  "Superseded"
)

declare -A ADRS

echo "# Architecture Decision Records Index" > "$INDEX_FILE"
echo "" >> "$INDEX_FILE"
echo "_This file is auto-generated. Do not edit manually._" >> "$INDEX_FILE"
echo "" >> "$INDEX_FILE"

for file in "$ADR_DIR"/*.md; do
  [[ -f "$file" ]] || continue

  filename=$(basename "$file")

  # Extract ADR number and title
  header=$(grep -m 1 '^# ' "$file" || true)
  if [[ -z "$header" ]]; then
    echo "ERROR: Missing ADR title in $file"
    exit 1
  fi

  adr_id=$(echo "$header" | awk '{print $2}')
  title=$(echo "$header" | cut -d':' -f2- | sed 's/^ //')

  # Extract status
  status=$(awk '
    /^## Status/ {getline; print; exit}
  ' "$file" | tr -d '\r')

  if [[ -z "$status" ]]; then
    echo "ERROR: Missing ADR status in $file"
    exit 1
  fi

  # Validate status
  valid=false
  for allowed in "${ALLOWED_STATUSES[@]}"; do
    if [[ "$status" == "$allowed"* ]]; then
      valid=true
      canonical_status="$allowed"
      break
    fi
  done

  if [[ "$valid" != true ]]; then
    echo "ERROR: Invalid ADR status '$status' in $file"
    echo "Allowed statuses: ${ALLOWED_STATUSES[*]}"
    exit 1
  fi

  ADRS["$canonical_status"]+="- [$adr_id]($ADR_DIR/$filename) $title"$'\n'
done

# Output sections in a fixed, auditable order
for status in "${ALLOWED_STATUSES[@]}"; do
  if [[ -n "${ADRS[$status]:-}" ]]; then
    echo "## $status" >> "$INDEX_FILE"
    echo "" >> "$INDEX_FILE"
    echo "${ADRS[$status]}" >> "$INDEX_FILE"
  fi
done
