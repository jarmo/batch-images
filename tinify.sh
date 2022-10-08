#!/bin/bash

set -Eeo pipefail

IMAGE_PATHS=("$@")

if [[ -z "${IMAGE_PATHS[0]}" ]]; then 
  echo "Usage: $0 IMAGE..."
  exit 1
fi

if [[ -z "$TINIFY_API_KEY" ]]; then
  echo "TINIFY_API_KEY environment variable is missing, can't continue"
  exit 1
fi

for IMAGE_PATH in "${IMAGE_PATHS[@]}"; do
  find "$IMAGE_PATH" \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \) -print0 | while IFS= read -r -d '' IMAGE; do
    echo
    echo "Processing $IMAGE"

    if echo "$IMAGE" | grep -qE "\-tin\..+$"; then
      echo "Already tinified, skipping"
      continue
    fi

    TINIFIED_IMAGE_URL="$(curl -s --user api:"$TINIFY_API_KEY" --data-binary @"$IMAGE" https://api.tinify.com/shrink | jq -r '.output.url')"

    IMAGE_FILE_NAME="$(basename "$IMAGE")"
    IMAGE_FILE_NAME_WITHOUT_EXT="${IMAGE_FILE_NAME%.*}"
    IMAGE_FILE_NAME_EXT="${IMAGE_FILE_NAME##*.}"
    NEW_IMAGE_PATH="$(dirname "$IMAGE")/$IMAGE_FILE_NAME_WITHOUT_EXT-tin.$IMAGE_FILE_NAME_EXT"

    echo "Saving tinified image to $NEW_IMAGE_PATH"
    curl -so "$NEW_IMAGE_PATH" "$TINIFIED_IMAGE_URL"
  done
done
