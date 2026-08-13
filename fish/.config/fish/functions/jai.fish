# SPDX-FileCopyrightText: 2026 Harish Rajagopal <harish.rajagopals@gmail.com>
#
# SPDX-License-Identifier: MIT

function jai --wraps jai --description 'jai wrapper to include git roots'
    if ! type --query jai
        return 1
    end

    set args
    if git rev-parse --is-inside-work-tree &>/dev/null
        if test "$(git rev-parse --is-inside-work-tree)" = 'true'
            set --append args --dir (git rev-parse --show-toplevel)
        end
        set --append args --dir (git rev-parse --git-common-dir)
    end

    command jai $args $argv
end
