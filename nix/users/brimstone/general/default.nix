{ self, ... }:
{
    imports = [
        ./zsh.nix
        ./tmux.nix
        (import ./neovim.nix { inherit self; })
    ];
}
