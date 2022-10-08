all: test

shellcheck:
	shellcheck -V && shellcheck *.sh

test: shellcheck

.PHONY: all shellcheck test
