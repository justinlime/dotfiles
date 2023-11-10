{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    maxfetch = {
      url = "github:jobcmax/maxfetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pipecord = {
      url = "github:justinlime/pipecord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs_stable, home-manager, ... }@inputs:
  let
    username = "justinlime";

    # The path to this very repo 
    flake_path = "/home/${username}/dotfiles";

    allSystems = x: [
      (x + ".x86_64-linux")
      (x + ".x86_64-darwin")
      (x + ".aarch64-linux")
    ];

    allHomeConfigurations =  
      nixpkgs.lib.genAttrs (nixpkgs.lib.flatten (nixpkgs.lib.lists.forEach [
        "brimstone"
        "janus"
      ] allSystems)) # This will generate an entry for each profile and system, Example: brimstone.x86_64-linux
      (profile: 
          let
            split = nixpkgs.lib.strings.splitString "." profile;
            name = builtins.elemAt split 0;
            system =  builtins.elemAt split 1;
            pkgs = nixpkgs.legacyPackages.${system};
            pkgs_stable = nixpkgs_stable.legacyPackages.${system};
          in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit profile username flake_path pkgs_stable inputs; };
            modules = [
              ./nix/users/${name}
              # Pin registry to flake
              { nix.registry.nixpkgs.flake = nixpkgs; }
              # Pin channel to flake 
              { home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}"; }
            ];
          });
    allSystemConfigurations = 
      nixpkgs.lib.genAttrs (nixpkgs.lib.flatten (nixpkgs.lib.lists.forEach [
        "stinkserver"
        "jesktop"
        "japtop"
      ] allSystems))
      (profile: 
           let
             split = nixpkgs.lib.strings.splitString "." profile;
             name = builtins.elemAt split 0;
             system =  builtins.elemAt split 1;
             pkgs = nixpkgs.legacyPackages.${system};
             pkgs_stable = nixpkgs_stable.legacyPackages.${system};
           in
           nixpkgs.lib.nixosSystem {
             inherit system;
             specialArgs = { inherit profile username flake_path pkgs_stable inputs; }; 
             modules = [
               ./nix/systems/${name}
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
