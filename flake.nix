{
  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    inherit (builtins) head elemAt attrNames readDir; 
    inherit (nixpkgs.lib) importTOML flatten genAttrs splitString;

    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    jlib = import ./nix/lib/default.nix { lib = nixpkgs.lib; };

    # Shhhhh
    # Semi-private files encrypted with git-crypt. Profiles relying on these files will fail if not decrypted first.
    # Read all the files, and mush them into a top level hush attribute set; Expects TOML format
    hush = let dir = ./hush; temp = {}; in
      head (map (x: temp // (importTOML "${dir}/${x}")) (attrNames (readDir dir)));

    # Prefix every string in a given LIST with a given FLAG, seperated by dots
    #
    # EX: genProfileNames [ "brimstone" "janus" ] "x86_64-linux" => [ "brimstone.x86_64-linux" "janus.x86_64-linux"]
    genProfileNames = list: flag: (map (x: "${flag}.${x}") list);

    # Use the given FUNC to generate an attribute set, whose attribute name's are a profile,
    # based upon the names of the subdirs found in the given DIR, and the available systems.
    applyProfiles = dir: func: (genAttrs
        (flatten (map (genProfileNames systems)
          (attrNames (readDir ./nix/${dir})))) func);

    # Generate SYSTEM, PROFILENAME, and PKGS, based on a given profile.
    #
    # EX: genParams "brimstone.x86_64-linux" => { profileName = "brimstone"; system = "x86_64-linux"; pkgs = nixpkgs.legacyPackages.x86-64_linux; }
    genParams = profile: let split = splitString "." profile; in rec {
      profileName = elemAt split 0;            
      system =  elemAt split 1;         
      pkgs = nixpkgs.legacyPackages.${system};
    };

    # Generate a buildable configuration for every possible combination
    # of system architecture, and profile.
    #
    # The attribute names will be in the format of
    #
    # ${subdirname}.${system} 
    # 
    # EX: brimstone.x86_64-linux, brimstone.aarch64-linux, jesktop.x86_64-linux
    allHomeConfigurations = applyProfiles "users"
      (profile:                               
        with (genParams profile);
        # Bootstrap a home-manager profile using something like:
        # nix run --extra-experimental-features 'nix-command flakes' github:nix-community/home-manager -- switch --flake path:/home/justinlime/dotfiles#brimstone.x86_64-linux --experimental-features 'nix-command flakes'
        #
        # After first rebuild and subsequent shell reload, you can rebuild with the "home-switch" alias instead
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit profile hush jlib inputs; };
          modules = [
            ./nix/modules/users
            ./nix/users/${profileName}
            # enable flakes and nix-command after the first rebuild
            { nix = { package = pkgs.nix; settings.experimental-features = [ "nix-command" "flakes" ];}; }
            # Pin registry to flake
            { nix.registry.nixpkgs.flake = nixpkgs; }
            # Pin channel to flake 
            { home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}"; }
          ];
        });
    allSystemConfigurations = applyProfiles "systems"
      (profile: 
        with (genParams profile);
        # Bootstrap a system profile using something like:
        # nixos-rebuild switch --flake path:/home/justinlime/dotfiles#brimstone.x86_64-linux 
        #
        # After first build and subsequent shell reload, you can rebuild with the "nix-switch" alias instead
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit profile hush jlib inputs; }; 
          modules = [
            ./nix/modules/systems
            ./nix/systems/${profileName}
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
