#!/bin/bash

git update-index --assume-unchanged flake.nix
git update-index --assume-unchanged nix/systems/stinkserver/containers/duckdns.nix
git update-index --assume-unchanged nix/systems/stinkserver/containers/wireguard.nix

