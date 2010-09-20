#!/usr/bin/env bash

OS="`uname`"
INSTALL_LOCATION="`pwd`"

touch ~/.clj_completions # this file must exist or bad things happen

echo "# Put the following in your .bashrc or similar #"
echo ""
echo "source $INSTALL_LOCATION/activate.sh"
echo ""

