#!/bin/bash

set -Eeo pipefail

IMAGE_OUTPUT_FORMAT="$1"
shift || true
IMAGE_PATHS="$@"

if [[ -z "$IMAGE_OUTPUT_FORMAT" || -z "$IMAGE_PATHS" ]]; then 
  echo "Usage: "$0" IMAGE_OUTPUT_FORMAT IMAGE..."
  exit 1
fi

for IMAGE_PATH in ${IMAGE_PATHS[@]}; do
  for IMAGE in $(find "$IMAGE_PATH" -name "*.jpg" -o -name "*.png" -o -name "*.webp"); do
    echo
    echo "Processing $IMAGE"

    if echo "$IMAGE" | grep -qE "\.$IMAGE_OUTPUT_FORMAT"; then
      echo "Already in the specified output format, skipping"
      continue
    fi

    IMAGE_FILE_NAME="$(basename "$IMAGE")"
    IMAGE_FILE_NAME_WITHOUT_EXT="${IMAGE_FILE_NAME%.*}"
    NEW_IMAGE_PATH="$(dirname "$IMAGE")/$IMAGE_FILE_NAME_WITHOUT_EXT.$IMAGE_OUTPUT_FORMAT"

    echo "Converting to $NEW_IMAGE_PATH"
    convert -quiet "$IMAGE" "$NEW_IMAGE_PATH" 2>/dev/null || echo "Failed to convert"
  done
done
