{ pkgs
, ln-conf
, ...
}:

with pkgs;
let
  inherit (pkgs.lib) optional findFirst;

  mkMailEnv =
    { name
    , accounts
    , withAerc ? false
    }:
    let
      mkUtils = callPackage ./utils.nix { };
      mkMuttrc = callPackage ./mutt { };
      mkMbsyncrc = callPackage ./isync { };
      mkMsmtprc = callPackage ./msmtp { };

      utilsEnv = {
        paths = mkUtils accounts;
      };

      isyncEnv = {
        links."$HOME/.mbsyncrc" = "${mkMbsyncrc accounts}/etc/mbsyncrc";
        paths = [ isync ];
      };

      msmtpEnv = {
        links."$XDG_CONFIG_HOME/msmtp/config" = "${mkMsmtprc accounts}/etc/msmtprc";
        paths = [ msmtp ];
      };

      defaultOutlookAccount = findFirst
        (a: (a.type == "outlook" || a.type == "generic") && (a.name == "default"))
        null
        accounts;

      optionalMuttEnv = optional (defaultOutlookAccount != null)
        {
          links."$XDG_CONFIG_HOME/neomutt/muttrc" = "${mkMuttrc defaultOutlookAccount}/etc/muttrc";
          paths = [ neomutt ];
        };

      optionalAercEnv = optional withAerc
        {
          paths = [
            aerc
            w3m
            dante
          ];
        };

      extraEnv = {
        paths = [
          mu
          khal
          vdirsyncer
        ];
      };

      envs = [
        utilsEnv
        msmtpEnv
        isyncEnv
        extraEnv
      ]
      ++ optionalMuttEnv
      ++ optionalAercEnv;
    in
    (ln-conf.mkEnv "${name}-mail-env" envs) // {
      inherit accounts;
      addAccounts = a: mkMailEnv (accounts ++ a);
    };
in
mkMailEnv
