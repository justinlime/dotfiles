{ self, ... }:
{
    imports = [
        ./zsh.nix
        ./webcord.nix
        (import ./neovim.nix { inherit self; })
    ];
}
