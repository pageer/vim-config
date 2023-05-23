#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -s "$script_dir/_vimrc" $HOME/.vimrc
ln -s "$script_dir/vimfiles" $HOME/.vim
