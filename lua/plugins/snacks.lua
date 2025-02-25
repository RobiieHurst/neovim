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
        fps = 180, -- frames per second. Global setting for all animations
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
        preset = {
          header = [[
██████╗  ██████╗ ██████╗ ██████╗ ██╗███████╗
██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██║██╔════╝
██████╔╝██║   ██║██████╔╝██████╔╝██║█████╗  
██╔══██╗██║   ██║██╔══██╗██╔══██╗██║██╔══╝  
██║  ██║╚██████╔╝██████╔╝██████╔╝██║███████╗
╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚═╝╚══════╝]],
        },
      },
    },
  },
}
