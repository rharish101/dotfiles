# SPDX-FileCopyrightText: 2020 Harish Rajagopal <harish.rajagopals@gmail.com>
#
# SPDX-License-Identifier: MIT

# Environment variables for all sessions
export WINEPREFIX="$HOME/.wine/default" # default 64-bit wine prefix
export WINEDLLOVERRIDES="mshtml=d" # don't bug about gecko
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/lib64 # include CUDA
export TF_CPP_MIN_LOG_LEVEL=1 # hide TensorFlow INFO and DEBUG logs
