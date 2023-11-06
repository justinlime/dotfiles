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
    username = "justinlime";
    home_profile = "brimstone";
    system_profile = "jesktop";
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs_stable = nixpkgs_stable.legacyPackages.${system};
    # The path to this very repo 
    flake_path = "/home/${username}/dotfiles";
  in
  {
    homeConfigurations = {
      "${home_profile}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit username flake_path home_profile system_profile pkgs_stable inputs; };
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
      "${system_profile}" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit username flake_path home_profile system_profile pkgs_stable inputs; }; 
        modules = [
          ./nix/systems/${system_profile}
          { nix.registry.nixpkgs.flake = nixpkgs; }
          { nix.nixPath = [ "nixpkgs=configflake:nixpkgs" ]; }
        ];
      };
    };
  };
}
