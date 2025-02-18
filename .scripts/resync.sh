#!/usr/bin/env bash

cd $(dirname $0)/../

for element in ./cfg/*; do
    name=$(basename $element)
    echo "RM $element"
    rm -rf $element
    echo "CP ~/.config/$name $element"
    cp -rf $HOME/.config/$name $element
done
