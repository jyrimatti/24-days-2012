#!/bin/sh
test -e db && (
 nix-shell -p postgresql94 --command 'pg_ctl -D db start') || (
 nix-shell -p postgresql94 --command 'pg_ctl -D db init && pg_ctl -D db start && sleep 2 && createdb haskell')
