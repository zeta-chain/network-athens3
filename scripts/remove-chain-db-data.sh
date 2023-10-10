#!/bin/bash

killall zetacored
rm -rf ~/.zetacored/data/snapshots
rm -rf ~/.zetacored/data/cs.wal
rm -rf ~/.zetacored/data/*.db

