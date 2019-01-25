#!/bin/bash
CURRENTDIR=`pwd`
export PATH=$CURRENTDIR/bin:$CURRENTDIR/releasetools/:$PATH

prepare_pkg $CURRENTDIR/software/src  $CURRENTDIR/software/source
prepare_pkg $CURRENTDIR/software/tgt  $CURRENTDIR/software/target
#prepare_pkg $CURRENTDIR/software/src  $CURRENTDIR/software/test
