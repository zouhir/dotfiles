# atuin — local SQLite shell history. Sync is OFF unless `atuin register` is run.
# --disable-up-arrow keeps fish's native up-arrow history intact; use Ctrl-R for atuin.
if type -q atuin
    atuin init fish --disable-up-arrow | source
end
