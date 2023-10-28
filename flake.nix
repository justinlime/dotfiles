{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    maxfetch.url = "github:jobcmax/maxfetch";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {  self, nixpkgs, nixpkgs_stable, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    username = "justinlime";
    home_profile = "brimstone";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs_stable = nixpkgs.legacyPackages.${system};
    # The path to this very repo 
    flake_path = "~/dotfiles";
  in
  {
    homeConfigurations = {
      "${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit username flake_path pkgs_stable inputs; };
        modules = [
          ./nix/users/${home_profile}
          # Pin registry to flake
          { nix.registry.nixpkgs.flake = nixpkgs; }
          # Pin channel to flake 
          { home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}"; }
        ];
      };
    };
    nixosConfigurations = {
      japtop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit username flake_path pkgs_stable inputs; }; 
        modules = [
          ./nix/systems/main/laptop
          { nix.registry.nixpkgs.flake = nixpkgs; }
          { nix.nixPath = [ "nixpkgs=configflake:nixpkgs" ]; }
        ];
      };
      jesktop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit username flake_path pkgs_stable inputs; }; 
        modules = [
          ./nix/systems/main/desktop
          { nix.registry.nixpkgs.flake = nixpkgs; }
          { nix.nixPath = [ "nixpkgs=flake:nixpkgs" ]; }
        ];
      };
    };
  };
}
