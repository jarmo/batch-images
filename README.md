# Batch Images

Shell scripts to batch resize, convert and optimize images.

Supported input image file extensions:
* jpg
* png
* webp

## resize.sh

`resize.sh` is used to resize images to a smaller dimensions from the original.
Aspect ratio is preserved and no resizing happens when input image is smaller
than specified desired width.

ImageMagick's `identify` and `convert` binaries are required to perform the resizing.

```
./resize.sh 1024 input.jpg
./resize.sh 512 input-1.jpg input-2.jpg input-dir/
```

## convert.sh

`convert.sh` is used to convert an image from one format to another.

ImageMagick's `convert` binary is required to perform the conversion.

```
./convert.sh webp input.jpg
./convert.sh png input-1.jpg input-2.jpg input-dir/
```

## tinify.sh

`tinify.sh` is used to optimize images by using [tinify.com]() web service.

`TINIFY_API_KEY` environment variable needs to be set to use this script.
You can get an API key from the Tinify web service.

```
./tinify.sh input.jpg
./tinify.sh input-1.jpg input-2.jpg input-dir/
```

## Testing

Run `make test` to run `shellcheck` against all the scripts in this directory.
