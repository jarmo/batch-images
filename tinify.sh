#!/bin/bash

set -Eeo pipefail

IMAGE_PATHS="$@"

if [[ -z "$IMAGE_PATHS" ]]; then 
  echo "Usage: "$0" IMAGE..."
  exit 1
fi

if [[ -z "$TINIFY_API_KEY" ]]; then
  echo "TINIFY_API_KEY environment variable is missing, can't continue"
  exit 1
fi

for IMAGE_PATH in ${IMAGE_PATHS[@]}; do
  for IMAGE in $(find "$IMAGE_PATH" -name "*.jpg" -o -name "*.png" -o -name "*.webp"); do
    echo
    echo "Processing $IMAGE"

    if echo "$IMAGE" | grep -qE "\-opt\..+$"; then
      echo "Already optimized, skipping"
      continue
    fi

    OPTIMIZED_IMAGE_URL="$(curl -s --user api:"$TINIFY_API_KEY" --data-binary @$IMAGE https://api.tinify.com/shrink | jq -r '.output.url')"

    IMAGE_FILE_NAME="$(basename "$IMAGE")"
    IMAGE_FILE_NAME_WITHOUT_EXT="${IMAGE_FILE_NAME%.*}"
    IMAGE_FILE_NAME_EXT="${IMAGE_FILE_NAME##*.}"
    NEW_IMAGE_PATH="$(dirname "$IMAGE")/$IMAGE_FILE_NAME_WITHOUT_EXT-opt.$IMAGE_FILE_NAME_EXT"

    echo "Saving optimized image to $NEW_IMAGE_PATH"
    curl -so "$NEW_IMAGE_PATH" "$OPTIMIZED_IMAGE_URL"
  done
done
