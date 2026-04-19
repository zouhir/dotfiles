# mise — unified version manager. All state stays under ~/.local/share/mise.
# Coexists with fnm for now; migrate per-project via `mise use node@lts` etc.
if type -q mise
    mise activate fish | source
end
