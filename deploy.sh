#!/usr/bin/env bash
set ex
DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
LOAD_DIR=/tmp/tmux_load
LOAD_BIN=/usr/local/bin/tmux-mem-cpu-load
PLUGIN_DIR=$HOME/.tmux/plugins/tpm

function check_bin(){
    if [ -x "$LOAD_BIN" ]; then
        echo "binary is installed."
        return 0
    else
        return 1
    fi
}
function check_load(){
    if [ -d "$LOAD_DIR" ]; then
        echo "load directory already exists"
        return 0
    else
        git clone git://github.com/thewtex/tmux-mem-cpu-load.git "$LOAD_DIR"
        return $?
    fi
}
function install_load(){
    echo "installing..."
    cd "$LOAD_DIR"   
    cmake . && make && sudo make install
    return $?
}

function cleanup(){
    echo "cleaning up..."
    if [ -d "$LOAD_DIR" ]; then
        rm -rf "$LOAD_DIR"
    fi
}
echo "$DIR"
git clone https://github.com/tmux-plugins/tpm $PLUGIN_DIR
check_bin || ((check_load && install_load)|| cleanup)
if check_bin; then
    cp $DIR/tmux.conf ~/.tmux.conf
    echo "installation successful"
else
    echo "installation unsuccessful"
fi



