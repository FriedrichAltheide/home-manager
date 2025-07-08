{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkOption
    ;

  cfg = config.programs.docker-cli;

  jsonFormat = pkgs.formats.json { };
in
{
  meta.maintainers = [ lib.maintainers.friedrichaltheide ];

  options.programs.docker-cli = {
    configPath = mkOption {
      type = lib.types.str;
      default = ".docker/config.json"
      description = ''
        Relative path to the home directory of the user where the docker cli settings are saved'.
        The DOCKER_CONFIG environment variable is set accordingly if at least one setting is set.
      ''
      ;
    };

    settings = mkOption {
      type = jsonFormat.type;
      default = { };
      example = ''
        {
          "proxies" = {
            "default" = {
              "httpProxy" = "http://proxy.example.org:3128";
              "httpsProxy" = "http://proxy.example.org:3128";
              "noProxy" = "localhost";
            };
          };
      '';
      description = ''
        Available configuration options for the Docker CLI see:
        <https://docs.docker.com/reference/cli/docker/#docker-cli-configuration-file-configjson-properties
      '';
    };
  };

  config = lib.optionalAttrs (cfg.settings != { }) {
    home = {
      sessionVariables = {
        DOCKER_CONFIG = "${config.home.homeDirectory}/${cfg.configPath}";
      };
      file = {
        "${cfg.configPath}" = {
          source = jsonFormat.generate "config.json" cfg.settings;
        };
      };
    };
  };
}
