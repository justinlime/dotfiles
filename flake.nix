{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = {  self, nixpkgs, home-manager, ... } @inputs:
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
    in
    {
        homeConfigurations = {
            justinlime = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = { inherit inputs; };
                modules = [
                    ./nix/users/justinlime
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
