{ ... }:
{
  imports =
  [ 
    ./configuration.nix
    ./neovim.nix
    ./emacs.nix
    ./tmux.nix
    ./zsh.nix
    ./packages.nix
  ];
}
