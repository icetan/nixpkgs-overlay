{ cacert
, pass
, lib
, writeTextDir
}:

accounts: let
  mkCfg = { smtpHost, name, email, pass-path, ... }: ''
    account ${name}
    host ${smtpHost}
    port 587
    protocol smtp
    auth on
    from ${email}
    user ${email}
    passwordeval ${pass}/bin/pass show ${pass-path} | head -n1
    tls on
    tls_starttls on
    tls_trust_file ${cacert}/etc/ssl/certs/ca-bundle.crt
  '';
  tmpls = {
    "generic" = mkCfg;
    "gmail" = account: mkCfg (account // { smtpHost = "smtp.gmail.com"; });
    "outlook" = account: mkCfg (account // { smtpHost = "smtp.office365.com"; });
  };
  msmtprc = writeTextDir "/etc/msmtprc"
    (lib.concatMapStringsSep "\n" (a: tmpls."${a.type}" a) accounts);
in
msmtprc

#runCommand "msmtp-wrapper" { buildInputs = [ makeWrapper ]; } ''
#  makeWrapper ${msmtp}/bin/msmtp $out/bin/msmtp \
#    --add-flags '-C ${msmtprc}'
#  ln -s ${msmtp}/share $out
#''
