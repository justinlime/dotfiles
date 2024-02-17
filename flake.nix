{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    inherit (nixpkgs.lib) flatten genAttrs splitString;
    inherit (builtins) getEnv elemAt attrNames readDir; 
    # Impure, I dont care, use the current users' username
    username = (getEnv "USER");

    # The path to this very repo, used for shell aliases
    # Instead of using: sudo nixos-rebuild switch --flake path:/home/justinlime/dotfiles#brimstone.x86_64-linux --impure
    # After the first build this command is aliased to just: nix-switch
    # You will have to reload your shell for the aliases to take affect
    flake_path = (getEnv "HOME") + "/dotfiles";

    # When given a directory in the ./nix directory, such as "users" 
    # it will generate a list of possible profiles, which is in the format of ${profilename}.${system}
    # and supply each profile generated from the given directory (./nix/users) as an arguement to a function
    # Generated Profile List Example: brimstone.x86_64-linux, brimstone.aarch64-linux, janus.x86_64-linux, etc
    applyProfiles = dir: (genAttrs (flatten (map
      (x: (map (y: "${x}.${y}") (import ./nix/platforms.nix)))
        (attrNames (readDir ./nix/${dir})))));

    allHomeConfigurations = applyProfiles "users"
      (profile:                               # Example evaluations: 
          let                                 # profile = "brimstone.x86_64-linux"
            split = splitString "." profile;  # split   = [ "brimstone" "x86_64-linux" ]
            name = elemAt split 0;            # name    = "brimstone"
            system =  elemAt split 1;         # system  = "x86_64-linux"
            pkgs = nixpkgs.legacyPackages.${system};
          in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit profile username flake_path inputs; };
            modules = [
              ./nix/users/${name}
              # Enable flakes after bootstrapping, if you dont have home-manager, flakes, or nix-command setup yet,
              # you can bootstrap this build for the first time on a system with something like:
              # nix run --extra-experimental-features 'nix-command flakes' github:nix-community/home-manager -- switch --flake path:/home/justinlime/dotfiles#brimstone.x86_64-linux --impure  --experimental-features 'nix-command flakes'
              { nix = { package = pkgs.nix; settings.experimental-features = [ "nix-command" "flakes" ];}; }
              # Pin registry to flake
              { nix.registry.nixpkgs.flake = nixpkgs; }
              # Pin channel to flake 
              { home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}"; }
            ];
          });
    allSystemConfigurations = applyProfiles "systems"
      (profile: 
           let
             split = splitString "." profile;
             name = elemAt split 0;
             system =  elemAt split 1;
             pkgs = nixpkgs.legacyPackages.${system};
           in
           nixpkgs.lib.nixosSystem {
             inherit system;
             specialArgs = { inherit profile username flake_path inputs; }; 
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
