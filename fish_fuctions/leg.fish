# Defined in /home/leow/.config/fish/functions/leg.fish @ line 2
function leg
    set acc /tmp/.accumalator
    echo '' > $acc
    le accounts | awk '{ print length($0) " " $0 }' | sort | awk '{ print $2 }' >> $acc
    le payees | awk '{ print length($0) " @" $0 }' | sort | awk '{ print $2 }' >> $acc
    fzf --multi \
        --preview 'echo ledger --force-color {q} | sh' \
        --bind 'enter:preview(echo ledger --force-color {q} | sh),ctrl-d:preview(xargs -- echo < {f}),ctrl-b:preview(xargs -- ledger --force-color cleared < {f}),ctrl-m:preview(xargs -- ledger --force-color r < {f}),ctrl-h:preview(ledger --help)' \
        --preview-window top:90% --sync \
        --keep-right < $acc
end
