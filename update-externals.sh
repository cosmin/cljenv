#!/usr/bin/env bash

CWD=`pwd`
git submodule update --init

cd emacs/swank-clojure
git pull origin master
cd ../.. 

cd emacs/clojure-mode
git pull origin master
cd ..

cd $CWD
