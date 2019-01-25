#!/bin/bash
CURRENTDIR=`pwd`
export PATH=$PATH:$CURRENTDIR/bin
#akey=$CURRENTDIR/TCT_releasekey/releasekey
akey=$CURRENTDIR/testkeys/testkey
./bin/gen_update_pkg \
  tgt=$CURRENTDIR/software/target.zip \
  key=$akey \
  -pwd=123444 \
  $CURRENTDIR/software/update.zip \
  cu=4019X-2FOTABJ
