function brewr2x --description 'Executes brew packages from Rosetta2 brew'
        begin; set -lx PATH /usr/local/bin; eval $param $argv; end
end