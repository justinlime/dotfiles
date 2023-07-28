{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = {  self, nixpkgs, home-manager, ... }@inputs:
    let
        system = "x86_64-linux";
        username = "justinlime";
        pkgs = nixpkgs.legacyPackages.${system};
    in
    {
        homeConfigurations = {
            "${username}" = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = { inherit username inputs; };
                modules = [
                    ./nix/users/brimstone
                ];
            };
        };
        nixosConfigurations = {
            japtop = nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = { inherit inputs; }; 
                modules = [
                    ./nix/systems/main/laptop
                ];
            };
            jesktop = nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = { inherit inputs; }; 
                modules = [
                    ./nix/systems/main/desktop
                ];
            };
        };
    };
}
