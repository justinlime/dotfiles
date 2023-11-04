#!/bin/bash

# Run this with "bash prepare-repo.sh" from inside of the repo

# This just prepares the repo after a new clone to not track certain files, but still have
# them visible to git and nix. This is done incase the files might have sensitive information,
# or if they have imperative settings like my flake (setting the user and system profile).

git add --intent-to-add flake.nix
git add --intent-to-add nix/systems/stinkserver/containers/wireguard.nix
git add --intent-to-add nix/systems/stinkserver/containers/duckdns.nix

git update-index --assume-unchanged flake.nix
git update-index --assume-unchanged nix/systems/stinkserver/containers/wireguard.nix
git update-index --assume-unchanged nix/systems/stinkserver/containers/duckdns.nix

clear
echo -e "Done!\n"
git status
