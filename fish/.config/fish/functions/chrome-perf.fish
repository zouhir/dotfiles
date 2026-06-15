function chrome-perf --description 'Launch Chrome for performance testing with no extensions and a fresh profile'
    set -l profile (mktemp -d -t chrome-perf)
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
        --disable-extensions \
        --user-data-dir=$profile \
        --no-first-run \
        --no-default-browser-check \
        $argv
end
