return {
  "nvim-treesitter/nvim-treesitter",
  version = false, -- last release is way too old and doesn't work on Windows
  build = ":TSUpdate",
  event = { "LazyFile", "VeryLazy" },
  init = function(plugin)
    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    -- no longer trigger the **nvim-treesitter** module to be loaded in time.
    -- Luckily, the only things that those plugins need are the custom queries, which we make available
    -- during startup.
    require("lazy.core.loader").add_to_rtp(plugin)
    require("nvim-treesitter.query_predicates")
  end,
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  keys = {
    { "<c-space>", desc = "Increment Selection" },
    { "<bs>", desc = "Decrement Selection", mode = "x" },
  },
  opts_extend = { "ensure_installed" },
  ---@type TSConfig
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    -- A list of parser names, or "all"
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "query",
      "regex",
      "rust",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    },
    
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    
    -- Automatically install missing parsers when entering buffer
    auto_install = true,
    
    highlight = {
      enable = true,
      -- Disable highlighting for problematic situations to prevent range errors
      disable = function(lang, buf)
        -- Check if buffer is valid
        if not buf or not vim.api.nvim_buf_is_valid(buf) then
          return true
        end
        
        -- Disable for large files
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
        
        -- Disable for certain problematic filetypes
        local problematic_langs = { 
          "git", "gitcommit", "gitrebase", "gitconfig",
          "help", "man", "terminal", "qf"
        }
        for _, problematic_lang in ipairs(problematic_langs) do
          if lang == problematic_lang then
            return true
          end
        end
        
        -- Check if buffer has reasonable line count
        local line_count = vim.api.nvim_buf_line_count(buf)
        if line_count > 10000 then
          return true
        end
        
        return false
      end,
      
      -- Use more conservative additional highlighting
      additional_vim_regex_highlighting = false,
    },
    
    indent = {
      enable = true,
      -- Disable indent for languages that might cause issues
      disable = { "python", "yaml" },
    },
    
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
    
    textobjects = {
      move = {
        enable = true,
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      },
    },
  },
  
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    
    -- Register custom parsers
    local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    
    -- Add templ parser for Go templating
    treesitter_parser_config.templ = {
      install_info = {
        url = "https://github.com/vrischmann/tree-sitter-templ.git",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "master",
      },
    }
    
    -- Register the templ filetype
    vim.treesitter.language.register("templ", "templ")
    
    -- Add simple error suppression for treesitter range errors
    local original_error = vim.api.nvim_err_writeln
    vim.api.nvim_err_writeln = function(msg)
      -- Suppress specific treesitter range errors that don't affect functionality
      if type(msg) == "string" and (
        msg:match("Invalid.*end_col.*out of range") or
        msg:match("Error in decoration provider")
      ) then
        -- Silently ignore these specific treesitter errors
        return
      end
      return original_error(msg)
    end
  end,
}