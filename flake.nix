{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        maxfetch.url = "github:jobcmax/maxfetch";
    };

    outputs = {  self, nixpkgs, home-manager, ... }@inputs:
    let
        system = "x86_64-linux";
        username = "justinlime";
        pkgs = nixpkgs.legacyPackages.${system};
        # Directs home-switch, nix-switch, all-switch, and all-update 
        # aliases to directory that contains the flake
        flake_path = "~/dotfiles";
    in
    {
        homeConfigurations = {
            "${username}" = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = { inherit username flake_path inputs; };
                modules = [
                    ./nix/users/brimstone
                    # Pin registry to flake
                    { nix.registry.nixpkgs.flake = nixpkgs; }
                    # Pin channel to flake 
                    { home.sessionVariables.NIX_PATH = "nixpkgs=nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}"; }
                ];
            };
        };
        nixosConfigurations = {
            japtop = nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = { inherit username flake_path inputs; }; 
                modules = [
                    ./nix/systems/main/laptop
                    { nix.registry.nixpkgs.flake = nixpkgs; }
                    { nix.nixPath = [ "nixpkgs=configflake:nixpkgs" ]; }
                ];
            };
            jesktop = nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = { inherit username flake_path inputs; }; 
                modules = [
                    ./nix/systems/main/desktop
                    { nix.registry.nixpkgs.flake = nixpkgs; }
                ];
            };
        };
    };
}
