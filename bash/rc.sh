function edit () { emacsclient -c $* &> /dev/null & }
RR() { command sed -n $1,$2p $3 2> /dev/null | R --vanilla --silent ; }
pcalc() { python3 -c "print ($*)" ;}
function nb() { jupyter notebook $@ &> /dev/null & }
function cd-tmp() {
    dest=$HOME/tmp/$(date '+%d-%b-%Y')
    mkdir -p $dest
    cd $dest
}
