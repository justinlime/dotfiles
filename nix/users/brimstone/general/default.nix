{ self, ... }:
{
    imports = [
        ./zsh.nix
        (import ./neovim.nix { inherit self; })
    ];
}
