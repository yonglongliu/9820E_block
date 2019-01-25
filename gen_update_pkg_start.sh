#!/bin/bash
CURRENTDIR=`pwd`
export PATH=$CURRENTDIR/bin:$CURRENTDIR/releasetools/:$PATH
#key=$CURRENTDIR/TCT_releasekeys/releasekey \
#  -pwd=mikeh888888 \
key=$CURRENTDIR/testkeys/releasekey

gen_update_pkg \
  src=$CURRENTDIR/software/source.zip \
  tgt=$CURRENTDIR/software/target.zip \
  key=$key \
  -pwd=xunrui888 \
  $CURRENTDIR/software/update.zip \
