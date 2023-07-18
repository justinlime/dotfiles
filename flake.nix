{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = {  nixpkgs, home-manager, ... }:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config = {
                allowUnfree = true;
            };
        };
    in
    {
        homeConfigurations = {
            justinlime = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = { inherit nixpkgs system; };
                modules = [
                    ./nix/users/main/home.nix 
                ];
            };
        };
        nixosConfigurations = {
            japtop = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                    ./nix/systems/main/laptop/laptop.nix 
                ];
            };
            jesktop = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                    ./nix/systems/main/desktop/desktop.nix
                ];
            };
        };
    };
}
