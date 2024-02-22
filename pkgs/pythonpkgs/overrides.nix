{ pkgs
, python
, ...
}:

self: super: {

  aider-chat = super.aider-chat.overridePythonAttrs (old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
      self.setuptools
    ];
  });

  pyee = super.pyee.overridePythonAttrs (old: {
    postPatch = "";
  });

  soundfile = super.soundfile.overridePythonAttrs (old: {
    postPatch = "";
  });

  ta-lib = super.ta-lib.overridePythonAttrs (old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
      pkgs.ta-lib
      self.setuptools
      self.wheel
    ];
  });

  ta = super.ta.overridePythonAttrs (old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
      pkgs.ta-lib
      self.setuptools
      self.wheel
    ];
  });

  pandas-ta = super.pandas-ta.overridePythonAttrs (old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
      pkgs.ta-lib
      self.setuptools
      self.wheel
    ];
  });

  sklearn = super.sklearn.overridePythonAttrs (old: {
    SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL = "True";

    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
      self.setuptools
      self.wheel
    ];
  });
}
