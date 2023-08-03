{ inputs , pkgs, ... }:
{
    home.packages = with pkgs; [
      neovim
    ];
    xdg.configFile = {
        "nvim".source = "${inputs.self}/.config/nvim";
    };
}
