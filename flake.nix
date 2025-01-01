{
  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    inherit (builtins) head elemAt attrNames readDir; 
    inherit (nixpkgs.lib) importTOML flatten genAttrs splitString;

    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

    # Shhhhh
    # Read all the files, and mush them into a top level hush attribute set; Expects TOML format
    hush =
      let
        dir = ./hush; temp = {};
      in
        head (map (x: temp // (importTOML "${dir}/${x}")) (attrNames (readDir dir)));

    # Prefix every string in a ${list} with a given ${flag}, seperated by dots
    #
    # EX: addFlags [ "brimstone" "janus" ] "x86_64-linux" -> [ "brimstone.x86_64-linux" "janus.x86_64-linux"]
    addFlags = list: flag: (map (y: "${flag}.${y}") list);

    # Add flags for every username, home profile, and system profile (directory containing a default.nix file)
    # in a given dir, then apply a given function to each attribute in the resulting set
    applyProfiles = dir: func: (genAttrs
        (flatten (map (addFlags systems)
          (attrNames (readDir ./nix/${dir})))) func);

    setParams = profile: rec {
      # Split the attribute's name into independant variables
      #
      # EX: brimstone.x86_64-linux -> [ "brimstone" "x86_64-linux" ]
      split = splitString "." profile;  
      name = elemAt split 0;            
      system =  elemAt split 1;         
      pkgs = nixpkgs.legacyPackages.${system};
    };

    # Generate a attributes in a set for every possible combination
    # of system, and profile. The attribute names will be in the format of
    #
    # ${profile}.${system}
    #
    # EX: brimstone.x86_64-linux jesktop.x86_64-linux
    allHomeConfigurations = applyProfiles "users"
      (profile:                               
        with (setParams profile);
        # after first build and subsequent shell reload, you can rebuild with the "home-switch" alias instead
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit profile hush inputs; };
          modules = [
            ./nix/modules/users
            ./nix/users/${name}
            # Enable flakes after bootstrapping, if you dont have home-manager, flakes, or nix-command setup yet,
            # you can bootstrap this build for the first time on a system with something like:
            # nix run --extra-experimental-features 'nix-command flakes' github:nix-community/home-manager -- switch --flake path:/home/justinlime/dotfiles#brimstone.x86_64-linux --experimental-features 'nix-command flakes'
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
          specialArgs = { inherit profile hush inputs; }; 
          modules = [
            ./nix/modules/systems
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
