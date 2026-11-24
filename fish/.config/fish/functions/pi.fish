# SPDX-FileCopyrightText: 2026 Harish Rajagopal <harish.rajagopals@gmail.com>
#
# SPDX-License-Identifier: MIT

function pi --wraps pi
    set --local pi_bin (type --path --no-functions pi)
    if test -z "$pi_bin"
        echo 'Pi not installed' >&2
        return 127
    end

    set --local jai_cmd jai --jail pi --
    if ! type --query --no-functions jai
        echo 'jai not installed' >&2
        set --erase jai_cmd
    end

    set --local secrets (bws get item Pi.dev | jq -r '.fields[] | "\(.name)=\(.value)"')
    env PI_SKIP_VERSION_CHECK=1 $secrets $jai_cmd $pi_bin $argv
end
