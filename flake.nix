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

  outputs = { self, nixpkgs, nixpkgs_stable, home-manager, ... }@inputs:
  let
    username = "justinlime";
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs_stable = nixpkgs_stable.legacyPackages.${system};

    # The path to this very repo 
    flake_path = "/home/${username}/dotfiles";

    allHomeConfigurations =  
      nixpkgs.lib.genAttrs [
        "brimstone"
        "janus"
      ] (config: 
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit username flake_path pkgs_stable inputs; };
            modules = [
              ./nix/users/${config}
              # Pin registry to flake
              { nix.registry.nixpkgs.flake = nixpkgs; }
              # Pin channel to flake 
              { home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}"; }
            ];
          });
    allSystemConfigurations = 
      nixpkgs.lib.genAttrs [
        "stinkserver"
        "jesktop"
        "japtop"
      ] (config: 
           nixpkgs.lib.nixosSystem {
             inherit system;
             specialArgs = { inherit username flake_path pkgs_stable inputs; }; 
             modules = [
               ./nix/systems/${config}
               { nix.registry.nixpkgs.flake = nixpkgs; }
               { nix.nixPath = [ "nixpkgs=configflake:nixpkgs" ]; }
             ];
          });
  in
  {
    homeConfigurations = allHomeConfigurations; 
    nixosConfigurations = allSystemConfigurations; 
  };
}
