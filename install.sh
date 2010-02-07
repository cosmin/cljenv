#!/usr/bin/env bash

OS="`uname`"
INSTALL_LOCATION="`pwd`"

if [[ $OS = "Darwin" ]]; then
    BASHRC="~/.profile"
else
    BASHRC="~/.bashrc"
fi

echo "Initializing submodules"
git submodule update --init
touch ~/.clj_completions # this file must exist or bad things happen

echo "source $INSTALL_LOCATION/setup.sh" >> $BASHRC
echo "cljenv_autostart NOPS1" >> $BASHRC
echo "Added CLJENV setup.sh to be sourced by default"

echo "(load (concat (getenv \"CLJENV_HOME\") \"/\" \"setup.el\"))" >> ~/.emacs
echo "Added Shared Profile setup.el to Emacs"

echo ""
echo "Done."
