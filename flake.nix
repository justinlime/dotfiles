{
  outputs = { self, nixpkgs, nixpkgsStable, nixpkgsJustinLime, home-manager, ... }@inputs:
  let
    inherit (builtins) head fromTOML readFile elemAt attrNames readDir; 
    inherit (nixpkgs.lib) importTOML flatten genAttrs splitString;

    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

    usernames = [ "justinlime" ];

    # Shhhhh
    # Read all the files, and mush them into a top level hush attribute set; Expects TOML format
    hush =
      if (builtins.length usernames) != 0
      then { inherit usernames; } # Allow unencrypted username if set in this flake above
      else
        let
          dir = ./hush; temp = {};
        in
          head (map (x: temp // (importTOML "${dir}/${x}")) (attrNames (readDir dir)));
    # Prefix every string in a ${list} with a given ${flag}, seperated by dots
    #
    # EX: addFlags [ "brimstone" ] "x86_64-linux" -> [ "brimstone.x86_64-linux" ]
    addFlags = list: flag: (map (y: "${flag}.${y}") list);

    # Add flags for every username, home profile, and system profile (directory containing a default.nix file)
    # in a given dir, then apply a given function to each attribute in the resulting set
    applyProfiles = dir: func: (genAttrs
      (flatten (map (addFlags hush.usernames)
        (flatten (map (addFlags systems)
          (attrNames (readDir ./nix/${dir})))))) func);

    setParams = profile: rec {
      # Split the attribute's name into independant variables
      #
      # EX: brimstone.x86_64-linux.justinlime -> [ "brimstone" "x86_64-linux" "justinlime" ]
      split = splitString "." profile;  
      name = elemAt split 0;            
      system =  elemAt split 1;         
      username = elemAt split 2;
      pkgs = nixpkgs.legacyPackages.${system};
      pkgsStable = nixpkgsStable.legacyPackages.${system};
      pkgsJustinLime = nixpkgsJustinLime.legacyPackages.${system};
      flake_path = "/home/${username}/dotfiles";
    };

    # Generate a attributes in a set for every possible combination
    # of system, profile, and username. The attribute names will be in the format of
    #
    # ${profile}.${system}.${username}
    #
    # EX: brimstone.x86_64-linux.justinlime, jesktop.x86_64-linux.justinlime
    #
    # I use this for the variety of usernames and systems I might use so I
    # can pass them imperitevly in the rebuild commands.
    allHomeConfigurations = applyProfiles "users"
      (profile:                               
        with (setParams profile);
        # after first build and subsequent shell reload, you can rebuild with the "home-switch" alias instead
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit pkgsStable pkgsJustinLime profile username flake_path hush inputs; };
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
        with (setParams profile);
        # after first build and subsequent shell reload, you can rebuild with the "nix-switch" alias instead
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit pkgsJustinLime pkgsStable profile username flake_path hush inputs; }; 
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
    nixpkgsJustinLime.url = "github:justinlime/nixpkgs/jellyfin";
    nixpkgsStable.url = "github:nixos/nixpkgs/nixos-23.11";
    # nixpkgsStable.url = "github:nixos/nixpkgs?rev=8817fe97f02c8cdb761d01a1cfb65327444e0b17";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pipecord = {
      url = "github:justinlime/pipecord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fileserver = {
      url = "github:justinlime/go-fileserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
