# SPDX-FileCopyrightText: 2026 Harish Rajagopal <harish.rajagopals@gmail.com>
#
# SPDX-License-Identifier: MIT

function bws --wraps bw --description 'bw wrapper with session'
    if ! type --query bw
        echo 'BitWarden CLI not installed' >&2
        return 127
    end

    set --local bw_dir /tmp/bw
    set --local bw_session $bw_dir/session

    if ! BW_SESSION=(cat $bw_session 2>/dev/null) bw unlock --check &>/dev/null
        mkdir -p $bw_dir && chmod 700 $bw_dir
        set --local bw_tmp (mktemp $bw_dir/session.XXXXXX)

        bw unlock --raw >$bw_tmp
        if test -s "$bw_tmp"
            mv -f $bw_tmp $bw_session
            chmod 600 $bw_session
        else
            rm -f $bw_tmp $bw_session
            return 1
        end
    end

    BW_SESSION=(cat $bw_session 2>/dev/null) bw $argv
end
