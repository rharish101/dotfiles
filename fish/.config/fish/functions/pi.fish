# SPDX-FileCopyrightText: 2026 Harish Rajagopal <harish.rajagopals@gmail.com>
#
# SPDX-License-Identifier: MIT

function pi --wraps pi
    set secrets (bws get item Pi.dev | jq -r '.fields[] | "\(.name)=\(.value)"')
    env PI_SKIP_VERSION_CHECK=1 $secrets jai -j pi -- (type -pf pi)
end
