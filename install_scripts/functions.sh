#!/bin/bash

megamind(){
cat << EOF
⠀⣞⢽⢪⢣⢣⢣⢫⡺⡵⣝⡮⣗⢷⢽⢽⢽⣮⡷⡽⣜⣜⢮⢺⣜⢷⢽⢝⡽⣝
⠸⡸⠜⠕⠕⠁⢁⢇⢏⢽⢺⣪⡳⡝⣎⣏⢯⢞⡿⣟⣷⣳⢯⡷⣽⢽⢯⣳⣫⠇
⠀⠀⢀⢀⢄⢬⢪⡪⡎⣆⡈⠚⠜⠕⠇⠗⠝⢕⢯⢫⣞⣯⣿⣻⡽⣏⢗⣗⠏⠀
⠀⠪⡪⡪⣪⢪⢺⢸⢢⢓⢆⢤⢀⠀⠀⠀⠀⠈⢊⢞⡾⣿⡯⣏⢮⠷⠁⠀⠀
⠀⠀⠀⠈⠊⠆⡃⠕⢕⢇⢇⢇⢇⢇⢏⢎⢎⢆⢄⠀⢑⣽⣿⢝⠲⠉⠀⠀⠀⠀
⠀⠀⠀⠀⠀⡿⠂⠠⠀⡇⢇⠕⢈⣀⠀⠁⠡⠣⡣⡫⣂⣿⠯⢪⠰⠂⠀⠀⠀⠀
⠀⠀⠀⠀⡦⡙⡂⢀⢤⢣⠣⡈⣾⡃⠠⠄⠀⡄⢱⣌⣶⢏⢊⠂⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢝⡲⣜⡮⡏⢎⢌⢂⠙⠢⠐⢀⢘⢵⣽⣿⡿⠁⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠨⣺⡺⡕⡕⡱⡑⡆⡕⡅⡕⡜⡼⢽⡻⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣼⣳⣫⣾⣵⣗⡵⡱⡡⢣⢑⢕⢜⢕⡝⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⣴⣿⣾⣿⣿⣿⡿⡽⡑⢌⠪⡢⡣⣣⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⡟⡾⣿⢿⢿⢵⣽⣾⣼⣘⢸⢸⣞⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠁⠇⠡⠩⡫⢿⣝⡻⡮⣒⢽⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

EOF
}

# Applies to all
universal_install(){ 
    while true; do
        read -p "You are running $0 do you wish to continue?[y/n]> " yn
        case $yn in
            [Yy]* ) 
                echo "Proceeding with install"
                break
                ;;
            [Nn]* ) 
                echo "Exited"
                exit;;
            * ) 
                echo "Yes, or No?[y,n]";;
        esac
    done

    sudo rm -rf /root/.config/nvim
    sudo rm -rf /root/.local/state/share/nvim
    sudo rm -rf /root/.local/state/state/nvim
    sudo ln -rs ../.config/nvim /root/.config

    rm -rf ~/.config/nvim
    rm -rf ~/.local/state/share/nvim
    rm -rf ~/.local/state/state/nvim
    ln -rs ../.config/nvim ~/.config

    rm -rf ~/.config/home-manager
    mkdir ~/.config/home-manager
    ln -rs ../nix/users/main/home.nix ~/.config/home-manager
    ln -rs ../nix/users/main/dotfiles.nix ~/.config/home-manager

    rm -rf ~/.bashrc
    ln -rs ../.bashrc ~/.bashrc

    rm -rf ~/.bash_profile
    ln -rs ../.bash_profile ~/.bash_profile
}

# Nix Systems
nixdesktop_install(){
    sudo rm -rf /etc/nixos
    sudo mkdir /etc/nixos
    sudo ln -rs ../nix/systems/main/* /etc/nixos
    sudo nixos-rebuild switch
    home-manager switch
    clear
    megamind
    echo "Finished install for nix desktop"
    echo "System Updated"
}
nixlaptop_install(){
    sudo rm -rf /etc/nixos
    sudo mkdir /etc/nixos
    sudo ln -rs ../nix/systems/laptop/* /etc/nixos
    sudo nixos-rebuild switch
    home-manager switch
    clear
    megamind
    echo "Finished install for nix laptop"
    echo "System Updated"
}

# All other standard linux distros
linux_install(){
    rm -rf ~/.config/*
    sudo ln -rs ../.config/* ~/.config/* 
    clear
    megamind
    echo "Finished install for linux"
}

universal_install
