function prompt_seg_env
    # TokyoNight: green #9ece6a, cyan #7dcfff, orange #ff9e64, yellow #e0af68
    set -l segments

    # Node.js
    if test -f package.json; or test -f .nvmrc; or test -f .node-version
        set -l node_v (command node --version 2>/dev/null | string replace 'v' '')
        if test -n "$node_v"
            set -a segments (set_color 9ece6a)" $node_v"(set_color normal)
        end
    end

    # Rust
    if test -f Cargo.toml
        set -l rust_v (command rustc --version 2>/dev/null | string match -r '\d+\.\d+\.\d+')
        if test -n "$rust_v"
            set -a segments (set_color ff9e64)" $rust_v"(set_color normal)
        end
    end

    # Go
    if test -f go.mod
        set -l go_v (command go version 2>/dev/null | string match -r '\d+\.\d+\.\d+')
        if test -n "$go_v"
            set -a segments (set_color 7dcfff)" $go_v"(set_color normal)
        end
    end

    # Python
    if test -n "$VIRTUAL_ENV"; or test -f pyproject.toml; or test -f requirements.txt
        set -l py_v (command python3 --version 2>/dev/null | string match -r '\d+\.\d+\.\d+')
        if test -n "$py_v"
            set -a segments (set_color e0af68)" $py_v"(set_color normal)
        end
    end

    if test (count $segments) -gt 0
        echo -n "via"
        for seg in $segments
            echo -n " $seg"
        end
    end
end
