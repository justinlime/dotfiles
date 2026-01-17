{
  outputs = { nixpkgs, home-manager, lanzaboote, chaotic, ... }@inputs:
  let
    inherit (builtins) elemAt attrNames readDir; 
    inherit (nixpkgs.lib) flatten genAttrs splitString;

    # Supported Systems
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

    sharedModules = [ ./nix/lib ];

    # Prefix every string in a given LIST with a given FLAG, seperated by dots
    #
    # EX: getProfileNames [ "justinlime@jenovo" "justinlime1999@oracle" ] "x86_64-linux" => [ "justinlime@jenovo.x86_64-linux" "justinlime1999@oracle.x86_64-linux"]
    getProfileNames = list: flag: (map (x: "${flag}.${x}") list);

    # Generate a list of profile names based on the names of the subdirs in a given DIR
    # Pass each profile name to a given FUNC
    # FUNC should generate an attrset (like nixosSystem, or homeManagerConfiguration) using the profile name
    # Each generated attrset is put into a top level attrset, whose attrnames are the generated profile names
    # Returns the top level attrset
    genProfiles = dir: func: (genAttrs
        (flatten (map (getProfileNames systems)
          (attrNames (readDir dir)))) func);

    # Return an attrset of SYSTEM, PROFILENAME, and PKGS, based on a given profile.
    #
    # EX: getParameters "justinlime@jenovo.x86_64-linux" => { profileName = "justinlime@jenovo"; system = "x86_64-linux"; pkgs = nixpkgs.legacyPackages.x86-64_linux; }
    getParameters = profile: let split = splitString "." profile; in rec {
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
    allHomeConfigurations = genProfiles ./nix/users
      (profile:                               
        with (getParameters profile);
        # Bootstrap a home-manager profile using something like:
        # nix run --extra-experimental-features 'nix-command flakes' github:nix-community/home-manager -- switch --flake path:/home/justinlime/dotfiles#justinlime@jenovo.x86_64-linux --experimental-features 'nix-command flakes'
        #
        # After first rebuild and subsequent shell reload, you can rebuild with the "home-switch" alias instead
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit profile inputs; };
          modules = [
            ./nix/modules/users
            ./nix/users/${profileName}
          ] ++ sharedModules;
        });
    allSystemConfigurations = genProfiles ./nix/systems
      (profile: 
        with (getParameters profile);
        # Bootstrap a system profile using something like:
        # nixos-rebuild switch --flake path:/home/justinlime/dotfiles#stinkserver.x86_64-linux 
        #
        # After first build and subsequent shell reload, you can rebuild with the "nix-switch" alias instead
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit profile inputs; }; 
          modules = [
            lanzaboote.nixosModules.lanzaboote 
            chaotic.nixosModules.default
            inputs.dms.nixosModules.dank-material-shell
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
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
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
    lanzaboote = {
      url = "github:nix-community/lanzaboote";  
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
