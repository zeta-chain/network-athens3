#!/bin/bash

rm -rf ~/.zetacored/os_info/*
cp -a os_info/. ~/.zetacored/os_info/
zetacored collect-observer-info
zetacored add-observer-list
cp ~/.zetacored/config/genesis.json ./network_files/config/genesis.json