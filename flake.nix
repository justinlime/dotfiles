{
  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    inherit (builtins) head elemAt attrNames readDir; 
    inherit (nixpkgs.lib) importTOML flatten genAttrs splitString;

    # Supported Systems
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

    sharedModules = [ ./nix/lib ];

    # Shhhhh
    # Semi-private files encrypted with git-crypt. Profiles relying on these files will fail if not decrypted first.
    # Read all the files, and mush them into a top level hush attribute set; Expects TOML format
    hush = let dir = ./hush; temp = {}; in
      head (map (x: temp // (importTOML "${dir}/${x}")) (attrNames (readDir dir)));

    # Prefix every string in a given LIST with a given FLAG, seperated by dots
    #
    # EX: genProfileNames [ "justinlime@jenovo" "justinlime1999@oracle" ] "x86_64-linux" => [ "justinlime@jenovo.x86_64-linux" "justinlime1999@oracle.x86_64-linux"]
    genProfileNames = list: flag: (map (x: "${flag}.${x}") list);

    # Use the given FUNC to generate an attribute set, whose attribute name's are a profile,
    # based upon the names of the subdirs found in the given DIR, and the available systems.
    applyProfiles = dir: func: (genAttrs
        (flatten (map (genProfileNames systems)
          (attrNames (readDir dir)))) func);

    # Generate SYSTEM, PROFILENAME, and PKGS, based on a given profile.
    #
    # EX: genParams "justinlime@jenovo.x86_64-linux" => { profileName = "justinlime@jenovo"; system = "x86_64-linux"; pkgs = nixpkgs.legacyPackages.x86-64_linux; }
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
    # EX: justinlime@jenovo.x86_64-linux, justinlime@jenovo.aarch64-linux, justinlime@jenovo.x86_64-darwin, etc.
    allHomeConfigurations = applyProfiles ./nix/users
      (profile:                               
        with (genParams profile);
        # Bootstrap a home-manager profile using something like:
        # nix run --extra-experimental-features 'nix-command flakes' github:nix-community/home-manager -- switch --flake path:/home/justinlime/dotfiles#justinlime@jenovo.x86_64-linux --experimental-features 'nix-command flakes'
        #
        # After first rebuild and subsequent shell reload, you can rebuild with the "home-switch" alias instead
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit profile hush inputs; };
          modules = [
            ./nix/modules/users
            ./nix/users/${profileName}
          ] ++ sharedModules;
        });
    allSystemConfigurations = applyProfiles ./nix/systems
      (profile: 
        with (genParams profile);
        # Bootstrap a system profile using something like:
        # nixos-rebuild switch --flake path:/home/justinlime/dotfiles#stinkserver.x86_64-linux 
        #
        # After first build and subsequent shell reload, you can rebuild with the "nix-switch" alias instead
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit profile hush inputs; }; 
          modules = [
            ./nix/modules/systems
            ./nix/systems/${profileName}
          ] ++ sharedModules;
       });
  in
  {
    homeConfigurations = allHomeConfigurations; 
    nixosConfigurations = allSystemConfigurations; 
    homeManagerModules.default = { imports = [ ./nix/modules/users ]; };
    nixosModules.default = { imports = [ ./nix/modules/systems ]; };
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
