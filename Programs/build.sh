#!/bin/zsh

#  build.sh
#  Module Builder
#
#  Created by Elisa Silva on 07/10/21.
#  Copyright © 2021 Uhura. All rights reserved.

echo "Programs Builder"

echo "Building from: " `pwd`

make SAMPLE.bin &&
make LUI.bin
