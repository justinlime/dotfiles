{
  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    inherit (nixpkgs.lib) flatten genAttrs splitString;
    inherit (builtins) head fromTOML readFile elemAt attrNames readDir; 

    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

    # Shhhhh
    # Read all the files, and mush them into a top level hush attribute set
    hush = let dir = ./hush; temp = {}; in
      head (map (x: temp // (fromTOML (readFile "${dir}/${x}"))) (attrNames (readDir dir)));

    # This is a stinky way to add something like command line arguments to the switch
    # commands. The flags are seperated by .'s
    # I use this for the variety of usernames and systems I might use so I
    # can pass them imperitevly in the rebuild commands
    # EX: brimstone.x86_64-linux.justinlime, jesktop.x86_64-linux.justinlime
    addFlags = list: flag: (map (y: "${flag}.${y}") list);

    # Add flags for every home and system profile (directory containing a default.nix file)
    # in a given dir, and apply a function to each attribute in the resulting set
    applyProfiles = dir: func: (genAttrs
      (flatten (map (addFlags hush.usernames)
        (flatten (map (addFlags systems)
          (attrNames (readDir ./nix/${dir})))))) func);

    # Generate an attribute in the set for every possible combination
    # of systems, profiles, and usernames
    allHomeConfigurations = applyProfiles "users"
      (profile:                               
        let                                 
          # Split the attribute's name into independant variables
          # EX: brimstone.x86_64-linux.justinlime -> [ "brimstone" "x86_64-linux" "justinlime" ]
          split = splitString "." profile;  
          name = elemAt split 0;            
          system =  elemAt split 1;         
          username = elemAt split 2;
          pkgs = nixpkgs.legacyPackages.${system};
          flake_path = "/home/${username}/dotfiles";
        in
        # after first build and subsequent shell reload, you can rebuild with the "home-switch" alias instead
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit profile username flake_path hush inputs; };
          modules = [
            ./nix/users/${name}
            # Enable flakes after bootstrapping, if you dont have home-manager, flakes, or nix-command setup yet,
            # you can bootstrap this build for the first time on a system with something like:
            # nix run --extra-experimental-features 'nix-command flakes' github:nix-community/home-manager -- switch --flake path:/home/justinlime/dotfiles#brimstone.x86_64-linux.justinlime --experimental-features 'nix-command flakes'
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
          username = elemAt split 2;
          flake_path = "/home/${username}/dotfiles";
        in
         # after first build and subsequent shell reload, you can rebuild with the "nix-switch" alias instead
         nixpkgs.lib.nixosSystem {
           inherit system;
           specialArgs = { inherit profile username flake_path hush inputs; }; 
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
}
