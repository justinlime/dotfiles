{ 
    pkgs, 
    custom ? {
        font = "RobotoMono Nerd Font";
        fontsize = "12";
        cursor = "Numix-Cursor";
    },
    ... 
}:
{
    gtk = {
        enable = true;
        font.name = "${custom.font} ${custom.fontsize}";
        iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.catppuccin-papirus-folders;
        };
        cursorTheme = {
            name = "${custom.cursor}";
            package = pkgs.numix-cursor-theme;
        };
        theme = {
            name = "Catppuccin-GTK-Purple-Dark";
            package = pkgs.magnetic-catppuccin-gtk.override { accent = [ "purple" ]; };
        };
        gtk3.extraConfig = {
            Settings = ''
                gtk-application-prefer-dark-theme=1
                '';
        };
        gtk4.extraConfig = {
            Settings = ''
                gtk-application-prefer-dark-theme=1
                '';
        };
    };
}
