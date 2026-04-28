#!/bin/sh
zip -r -o -X NetProxy-$(grep 'version=' module.prop | awk -F '=' '{print $2}').zip ./ \
  -x '.git/*' \
  -x 'build.sh' \
  -x '.github/*' \
  -x 'update.json' \
  -x '.gitattributes'
