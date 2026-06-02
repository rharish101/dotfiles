# SPDX-FileCopyrightText: 2026 Harish Rajagopal <harish.rajagopals@gmail.com>
#
# SPDX-License-Identifier: MIT

function jai --wraps jai --description 'jai wrapper to include git roots'
    if ! type --query jai
        return 1
    end

    set dirs
    if git rev-parse --is-inside-work-tree &>/dev/null
        if test "$(git rev-parse --is-inside-work-tree)" = 'false'
            # Bare repo
            set root (git rev-parse --git-common-dir | path dirname)
        else
            set root (git rev-parse --show-toplevel)
        end
        set --append dirs $root

        # Check for worktree
        if test -f "$root/.git"
            set parent (git rev-parse --git-common-dir | path dirname)
            if test -d "$parent/.git"
                set --append dirs $parent
            end
        end

        # Check for submodule
        set superproject (git rev-parse --show-superproject-working-tree 2>/dev/null)
        if test -n "$superproject"
            set --append dirs $superproject
        end
    end

    set args
    for d in $dirs
        if test "$d" = '.'
            set d (pwd)
        end
        if test "$(path normalize $d)" != "$(path normalize (pwd))"
            set --append args --dir $d
        end
    end

    command jai $args $argv
end
