#!/bin/bash

# Prevents files being tracked with git without changing them. You need to use something like:
#
# sudo nixos-rebuild switch --flake path:/home/justinlime/dotfiles#stinkserver
#
# rather than:
#
# sudo nixos-rebuild switch --flake /home/justinlime/dotfiles#stinkserver
#
# For this to work properly, my configuration already has this aliased.
# This is done because some of the files contain sensitive information and/or imperatively
# set variables. This makes it so they wont be added and commited to the repo.
# This solution is a hack but the best I could find. Run this script with
# `bash prepare_repo.sh` from the repo upon first clone.

git update-index --assume-unchanged flake.nix
git update-index --assume-unchanged nix/systems/stinkserver/containers/duckdns.nix
git update-index --assume-unchanged nix/systems/stinkserver/containers/wireguard.nix

