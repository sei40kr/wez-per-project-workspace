# wez-per-project-workspace

[WezTerm](https://wezfurlong.org/wezterm) port of [tmux-project](https://github.com/sei40kr/tmux-project).

wez-per-project-workspace scans and lists projects in the specified directories
and allows you to create or switch to a workspace for each project.

## Installation

Clone this repository into your `$XDG_CONFIG_HOME/wezterm` directory:

```sh
git clone https://github.com/sei40kr/wez-pain-control.git $XDG_CONFIG_HOME/wezterm
```

## Usage

```lua
local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Add these lines:
config.keys = {
    {
        -- You can change the key binding to whatever you want:
        key = "g",
        mods = "LEADER",
        action = require("wez-per-project-workspace.plugin").action.ProjectWorkspaceSelect({
            base_dirs = {
                {
                    path = wezterm.home_dir .. "/ghq",
                    min_depth = 3,
                    max_depth = 3,
                },
            },
            rooters = { ".git" },
            shorten_paths = true,
        }),
    }
}

return config
```

## Options

| Option          | Default      | Description                                      |
| --------------- | ------------ | ------------------------------------------------ |
| `base_dirs`     | `{}`         | List of base directories to search for projects. |
| `rooters`       | `{ ".git" }` | List of rooters to search for project root.      |
| `shorten_paths` | `false`      | Whether to shorten the paths of projects.        |

### `base_dirs`

| Option      | Defualt  | Description                                                                               |
| ----------- | -------- | ----------------------------------------------------------------------------------------- |
| `path`      | Required | Base directory path.                                                                      |
| `min_depth` | `1`      | Minimum depth of project root. Setting this to `0` will add the `path` as a project root. |
| `max_depth` | `1`      | Maximum depth of project root. Setting this to `0` will add the `path` as a project root. |

## Tips

### Show current workspace name in the status bar

The code snippet below shows the basename of the current workspace in the status
bar:

```lua
wezterm.on("update-status", function(window, _)
    window:set_left_status(
        wezterm.format({
            { Attribute = { Intensity = "Bold" } },
            { Text = window:mux_window():get_workspace():gsub("^.*/", "") },
            "ResetAttributes",
        })
    )
end)
```
