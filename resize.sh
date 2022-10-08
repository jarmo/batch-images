#!/bin/bash

set -Eeo pipefail

MAX_WIDTH="$1"
shift || true
IMAGE_PATHS=("$@")

if [[ -z "$MAX_WIDTH" || -z "${IMAGE_PATHS[0]}" ]]; then 
  echo "Usage: $0 MAX_WIDTH IMAGE..."
  exit 1
fi

for IMAGE_PATH in "${IMAGE_PATHS[@]}"; do
  find "$IMAGE_PATH" \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \) -print0 | while IFS= read -r -d '' IMAGE; do
    echo
    echo "Processing $IMAGE"

    if echo "$IMAGE" | grep -qE "\-[0-9]+\..+$"; then
      echo "Already resized, skipping"
      continue
    fi

    IMAGE_WIDTH=$(identify -quiet -format "%w" "$IMAGE" 2>/dev/null || echo "")

    if [[ -z "$IMAGE_WIDTH" ]]; then
      echo "Failed to determine width, skipping"
      continue
    fi

    IMAGE_FILE_NAME="$(basename "$IMAGE")"
    IMAGE_FILE_NAME_WITHOUT_EXT="${IMAGE_FILE_NAME%.*}"
    IMAGE_FILE_NAME_EXT="${IMAGE_FILE_NAME##*.}"
    NEW_IMAGE_PATH="$(dirname "$IMAGE")/$IMAGE_FILE_NAME_WITHOUT_EXT-$MAX_WIDTH.$IMAGE_FILE_NAME_EXT"

    if [[ ! "$MAX_WIDTH" -gt "$IMAGE_WIDTH" ]]; then
      echo "Resizing to $NEW_IMAGE_PATH"
      convert -quiet -resize "$MAX_WIDTH"x "$IMAGE" "$NEW_IMAGE_PATH" 2>/dev/null || echo "Failed to resize"
    else
      echo "Image not large enough, skipping"
    fi
  done
done
