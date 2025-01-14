-- lazy.nvim
return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = {
        enabled = false,
        animate = {
          duration = { step = 15, total = 250 },
          easing = "linear",
        },
      },
      animate = {
        duration = 20, -- ms per step
        easing = "linear",
        fps = 120, -- frames per second. Global setting for all animations
      },

      styles = {
        dashbaord = {
          zindex = 10,
          height = 0,
          width = 0,
          bo = {
            bufhidden = "wipe",
            buftype = "nofile",
            buflisted = false,
            filetype = "snacks_dashboard",
            swapfile = false,
            undofile = false,
          },
          wo = {
            colorcolumn = "",
            cursorcolumn = false,
            cursorline = false,
            foldmethod = "manual",
            list = false,
            number = false,
            relativenumber = false,
            sidescrolloff = 0,
            signcolumn = "no",
            spell = false,
            statuscolumn = "",
            statusline = "",
            winbar = "",
            winhighlight = "Normal:SnacksDashboardNormal,NormalFloat:SnacksDashboardNormal",
            wrap = false,
          },
        },
      },
      dashboard = {
        width = 100,
        row = nil, -- dashboard position. nil for center
        col = nil, -- dashboard position. nil for center
        pane_gap = 4, -- empty columns between vertical panes
        autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
        -- These settings are used by some built-in sections
        preset = {
          -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
          ---@type fun(cmd:string, opts:table)|nil
          pick = nil,
          -- Used by the `keys` section to show keymaps.
          -- Set your custom keymaps here.
          -- When using a function, the `items` argument are the default keymaps.
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          -- Used by the `header` section
          header = [[
██████╗  ██████╗ ██████╗ ██████╗ ██╗███████╗
██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██║██╔════╝
██████╔╝██║   ██║██████╔╝██████╔╝██║█████╗  
██╔══██╗██║   ██║██╔══██╗██╔══██╗██║██╔══╝  
██║  ██║╚██████╔╝██████╔╝██████╔╝██║███████╗
╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚═╝╚══════╝]],
        },
        sections = {
          { section = "header" },
          -- {
          --   pane = 2,
          --   section = "terminal",
          --   cmd = "colorscript -e square",
          --   height = 4,
          -- },
          -- { section = "keys", gap = 1, padding = 1 },
          {
            icon = " ",
            desc = "Browse Repo",
            action = function()
              Snacks.gitbrowse()
            end,
          },
          function()
            local in_git = Snacks.git.get_root() ~= nil
            local cmds = {
              {
                title = "Notifications",
                cmd = "gh notify -s -a -n5",
                action = function()
                  vim.ui.open("https://github.com/notifications")
                end,
                -- key = "n",
                icon = " ",
                height = 4,
                enabled = true,
              },
              {
                title = "Open Issues",
                cmd = [[gh issue list -L 3 --json number,title,updatedAt --template '{{range .}}{{tablerow (printf "#%v" .number | autocolor "green") .title (timeago .updatedAt)}}{{end}}']],
                action = function()
                  vim.fn.jobstart("gh issue list --web", { detach = true })
                end,
                icon = " ",
                height = 5,
              },
              {
                icon = " ",
                title = "Open PRs",
                cmd = [[gh pr list -L 3 --json number,title,headRefName,updatedAt --template '{{range .}}{{tablerow (printf "#%v" .number | autocolor "green") .title .headRefName (timeago .updatedAt)}}{{end}}']],
                action = function()
                  vim.fn.jobstart("gh pr list --web", { detach = true })
                end,
                height = 5,
              },
              {
                icon = " ",
                title = "Git Status",
                cmd = "git --no-pager diff --stat -B -M -C",
                height = 10,
              },
            }
            return vim.tbl_map(function(cmd)
              return vim.tbl_extend("force", {
                section = "terminal",
                enabled = in_git,
                padding = 1,
                ttl = 5 * 60,
                indent = 3,
              }, cmd)
            end, cmds)
          end,
          { section = "startup" },
        },
      },
    },
  },
}
