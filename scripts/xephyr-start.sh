#!/usr/bin/env bash

Xephyr -br -ac -noreset -screen 1000x700 :3 &
sleep 1
DISPLAY=:3 awesome -c $(dirname $0)/../rc.lua
