{ self , ... }:
{
    xdg.configFile = {
        "nvim".source = "${self}/.config/nvim";
    };
}
