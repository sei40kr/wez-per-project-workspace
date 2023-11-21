{ mkShell, wezterm, wez-per-project-workspace, writeTextFile }:

let
  config = writeTextFile {
    name = "wez-per-project-workspace-dev-shell-config.lua";
    text = ''
      package.path = package.path .. ";${wez-per-project-workspace}/?.lua"

      local wezterm = require("wezterm")

      local config = {}

      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.leader = { key = "b", mods = "CTRL" }

      config.keys = {
        {
          key = "g",
          mods = "LEADER",
          action = require("plugin").action.ProjectWorkspaceSelect({
            base_dirs = {
              {
                path = "${./examples}",
                min_depth = 1,
                max_depth = 2,
              },
            },
            rooters = { ".gitkeep" },
          }),
        }
      }

      return config
    '';
  };
in
mkShell {
  name = "wez-per-project-workspace-dev-shell";

  packages = [ wezterm ];

  shellHook = ''
    alias wezterm="wezterm --config-file ${config}"
  '';
}
