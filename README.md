# wez-per-project-workspace

[WezTerm](https://wezfurlong.org/wezterm) plugin for per-project workspace switching.

Scans projects in specified directories and allows you to create or switch to a workspace for each project.

## Features

- **Automatic Project Detection**: Automatically detects projects in specified base directories
- **Workspace Management**: Create and switch to independent workspaces for each project
- **Path Shortening**: Optionally shorten long project paths for better display

## Installation

Clone this repository into your WezTerm plugins directory:

```sh
git clone https://github.com/sei40kr/wez-per-project-workspace.git $XDG_CONFIG_HOME/wezterm/plugins/wez-per-project-workspace
```

## Basic Usage

Add the following configuration to your `wezterm.lua`:

```lua
local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Add project workspace selection functionality
config.keys = {
    {
        key = "g",
        mods = "LEADER",
        action = require("plugins.wez-per-project-workspace.plugin").action.ProjectWorkspaceSelect({
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

## Configuration Options

### Main Options

| Option          | Default      | Description                                     |
| --------------- | ------------ | ----------------------------------------------- |
| `base_dirs`     | `{}`         | List of base directories to search for projects |
| `rooters`       | `{ ".git" }` | Files/directories that identify project roots   |
| `shorten_paths` | `true`       | Whether to shorten project paths for display    |

### `base_dirs` Detailed Configuration

Each base directory can have the following options:

| Option      | Default  | Description                                                          |
| ----------- | -------- | -------------------------------------------------------------------- |
| `path`      | Required | Path to the base directory                                           |
| `min_depth` | `1`      | Minimum depth of project root (0 includes the base directory itself) |
| `max_depth` | `1`      | Maximum depth of project root (0 includes the base directory itself) |

## Examples

### Multiple Project Directories

```lua
action = require("plugins.wez-per-project-workspace.plugin").action.ProjectWorkspaceSelect({
    base_dirs = {
        {
            path = wezterm.home_dir .. "/ghq",
            min_depth = 2,
            max_depth = 4,
        },
        {
            path = wezterm.home_dir .. "/projects",
            min_depth = 1,
            max_depth = 2,
        },
        {
            path = wezterm.home_dir .. "/work",
            min_depth = 0,  -- Treat the work directory itself as a project
            max_depth = 0,
        }
    },
    rooters = { ".git", ".projectroot" },  -- Multiple rooters
    shorten_paths = true,
})
```

### Show Current Workspace in Status Bar

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

## How It Works

1. **Project Detection**: Uses `find` command to detect projects in specified base directories
2. **Root Identification**: Identifies project roots based on "rooters" like `.git` directories
3. **Workspace Management**: Creates and switches to independent workspaces for each project
4. **Fuzzy Search**: Uses WezTerm's InputSelector for fuzzy searching and selection

## Customization

### Changing Key Binding

```lua
config.keys = {
    {
        key = "p",  -- Change to LEADER + p
        mods = "LEADER",
        action = require("plugins.wez-per-project-workspace.plugin").action.ProjectWorkspaceSelect({
            -- Configuration options
        }),
    }
}
```

### Adding Custom Rooters

```lua
rooters = { ".git", ".project", "package.json", "Cargo.toml" }
```
