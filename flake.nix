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
    inherit (nixpkgs.lib) flatten genAttrs splitString;
    inherit (builtins) elemAt; 
    # The path to this very repo, used for shell aliases
    # Instead of using: sudo nixos-rebuild switch --flake path:/home/justinlime/dotfiles#brimstone.x86_64-linux 
    # After the first build this command is aliased to just: nix-switch
    flake_path = "/home/${username}/dotfiles";

    addSystems = x: [
      "${x}.x86_64-linux"
      "${x}.x86_64-darwin"
      "${x}.aarch64-linux"
    ];
    allHomeConfigurations =  
      genAttrs (flatten (map addSystems [
        "brimstone" # This will generate an entry for each profile and system in a list
        "janus"     # Example: [ "brimstone.x86_64-linux" "brimstone.x86_64-darwin" "janus.x86_64-linux" etc... ]
      ]))           # These are then split to generate the name of the config in the directory
      (profile:     # while also passing the system for each config 
          let                                    # Example evaluations: 
            split = splitString "." profile;     # brimstone.x86_64-linux to [ "brimstone" "x86_64-linux" ]
            name = elemAt split 0;               # [ "brimstone" "x86_64-linux" ] to brimstone
            system =  elemAt split 1;            # [ "brimstone" "x86_64-linux" ] to x86_64-linux
            pkgs = nixpkgs.legacyPackages.${system};
            pkgs_stable = nixpkgs_stable.legacyPackages.${system};
          in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit profile username flake_path pkgs_stable inputs; };
            modules = [
              ./nix/users/${name}
              # Enable flakes after bootstrapping, if you dont have home-manager, flakes, or nix-command setup yet,
              # you can bootstrap this build for the first time on a system with something like:
              # nix run --extra-experimental-features 'nix-command flakes' github:nix-community/home-manager -- switch --flake path:/home/justinlime/dotfiles#brimstone.x86_64-linux  --experimental-features 'nix-command flakes'
              { nix = { package = pkgs.nix; settings.experimental-features = [ "nix-command" "flakes" ];}; }
              # Pin registry to flake
              { nix.registry.nixpkgs.flake = nixpkgs; }
              # Pin channel to flake 
              { home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}"; }
            ];
          });
    allSystemConfigurations = 
      genAttrs (flatten (map addSystems [
        "stinkserver"
        "jesktop"
        "japtop"
      ]))
      (profile: 
           let
             split = splitString "." profile;
             name = elemAt split 0;
             system =  elemAt split 1;
             pkgs = nixpkgs.legacyPackages.${system};
             pkgs_stable = nixpkgs_stable.legacyPackages.${system};
           in
           nixpkgs.lib.nixosSystem {
             inherit system;
             specialArgs = { inherit profile username flake_path pkgs_stable inputs; }; 
             modules = [
               ./nix/systems/${name}
               { nix.settings.experimental-features = [ "nix-command" "flakes" ]; }
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
