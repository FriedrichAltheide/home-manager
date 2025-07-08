{
  config,
  ...
}
{
  programs.docker-cli = {
    settings = {
      "proxies" = {
        "default" = {
          "httpProxy" = "http://proxy.example.org:3128";
          "httpsProxy" = "http://proxy.example.org:3128";
          "noProxy" = "localhost";
        };
      };
    };
  };

  nmt.script = ''
    assertFileExists home-files/${config.docker-cli.configPath}
    assertFileContent home-files/${config.docker-cli.configPath} \
      ${./example-config.json}
  '';
}
