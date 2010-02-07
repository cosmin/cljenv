#!/usr/bin/env bash

OS="`uname`"
INSTALL_LOCATION="`pwd`"

echo "Initializing submodules"
git submodule update --init
touch ~/.clj_completions # this file must exist or bad things happen
echo ""

echo "= Put the following in your .bashrc or similar ="
echo ""
echo "source $INSTALL_LOCATION/setup.sh"
echo "cljenv_autostart NOPS1"
echo ""
echo ""

echo "= Put the following in your .emacs to get emacs support"
echo ""
echo "(load (concat (getenv \"CLJENV_HOME\") \"/\" \"setup.el\"))"
echo ""
echo ""
echo "Done."
