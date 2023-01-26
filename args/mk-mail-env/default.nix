{ pkgs
, ln-conf
, ...
}:

let
  inherit (pkgs) callPackage;
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
        paths = with pkgs; [ isync ];
      };

      msmtpEnv = {
        links."$HOME/.config/msmtp/config" = "${mkMsmtprc accounts}/etc/msmtprc";
        paths = with pkgs; [ msmtp ];
      };

      defaultOutlookAccount = findFirst
        (a: (a.type == "outlook" || a.type == "generic") && (a.name == "default"))
        null
        accounts;

      optionalMuttEnv = optional (defaultOutlookAccount != null)
        {
          links."$HOME/.config/neomutt/muttrc" = "${mkMuttrc defaultOutlookAccount}/etc/muttrc";
          paths = with pkgs; [ neomutt ];
        };

      optionalAercEnv = optional withAerc
        {
          paths = with pkgs; [
            aerc
            w3m
            dante
          ];
        };

      extraEnv = {
        paths = builtins.attrValues {
          inherit (pkgs) mu vdirsyncer khal;
        };
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
