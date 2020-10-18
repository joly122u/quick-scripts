# Defined in /tmp/fish.Bor8mm/leg.fish @ line 2
function leg
    set acc /tmp/.accumalator
    le accounts | awk '{ print length($0) "," $0 }' | sort > $acc;
    le payees | awk '{ print length($0) ",@" $0 }' | sort >> $acc;
    fzf --multi \
        --preview 'echo ledger {q} | sh' \
        --bind 'ctrl-l:preview(echo ledger {q} | sh),ctrl-b:preview(ledger b {}),ctrl-r:preview(ledger r {})' \
        --preview-window top:90% --with-nth 2 -d , --sync \
        --keep-right < $acc
end
