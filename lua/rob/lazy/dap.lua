return {
	{
		"mfussenegger/nvim-dap",
		recommended = true,
		desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

		dependencies = {
			"rcarriga/nvim-dap-ui",
			-- virtual text for the debugger
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
		},

		config = function()
			local dap = require("dap")

		  -- setup dap config by VsCode launch.json file
		  local vscode = require("dap.ext.vscode")
		  local json = require("plenary.json")
		  vscode.json_decode = function(str)
		    return vim.json.decode(json.json_strip_comments(str))
		  end

			if not dap.adapters["pwa-chrome"] then
				dap.adapters["pwa-chrome"] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "node",
						args = {
							require("mason-registry").get_package("js-debug-adapter"):get_install_path()
								.. "/js-debug/src/dapDebugServer.js",
							"${port}",
						},
					},
				}
			end
			if not dap.adapters["pwa-node"] then
				dap.adapters["pwa-node"] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "node",
						args = {
							require("mason-registry").get_package("js-debug-adapter"):get_install_path()
								.. "/js-debug/src/dapDebugServer.js",
							"${port}",
						},
					},
				}
			end
			for _, lang in ipairs({
				"javascript",
			}) do
				dap.configurations[lang] = dap.configurations[lang] or {}
				table.insert(dap.configurations[lang], {
					type = "pwa-chrome",
					request = "launch",
					name = "Launch Chrome against localhost",
					url = "http://localhost:3001",
					webRoot = "${workspaceFolder}",
					sourceMaps = true,
					-- protocol = "inspector",
				})

				table.insert(dap.configurations[lang], {
					type = "pwa-node",
					request = "launch",
					name = "Launch Bun Tests",
					runtimeExecutable = "bun",
					runtimeArgs = { "run", "tests" },
					program = "${file}",
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					protocol = "inspector",
					console = "integratedTerminal",
					skipFiles = { "<node_internals>/**" },
				})
			end


			dap.set_log_level("DEBUG")
			vim.keymap.set("n", "<F8>", dap.continue, { desc = "Debug: Continue" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Set Conditional Breakpoint" })

			require("dap.repl").config = {
				highlight = true,
				force_unicode = true,
				encoding = "utf-8",
				wrap = false,
			}

			dap.listeners.before.event_output["remove_ansi"] = function(_, body)
				if body.output then
					body.output = body.output:gsub("\27%[[0-9;]*m", "")
				end
			end
		end,

		-- config = function()
		--   -- load mason-nvim-dap here, after all adapters have been setup
		--   if LazyVim.has("mason-nvim-dap.nvim") then
		--     require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
		--   end
		--
		--   vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
		--
		--   for name, sign in pairs(LazyVim.config.icons.dap) do
		--     sign = type(sign) == "table" and sign or { sign }
		--     vim.fn.sign_define(
		--       "Dap" .. name,
		--       { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
		--     )
		--   end
		--
		-- end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
  -- stylua: ignore
  keys = {
    { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
    { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
  },
		opts = {
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.80 },
						{ id = "watches", size = 0.10 },
						{ id = "breakpoints", size = 0.10 },
						-- { id = "stacks", size = 0.25 },
					},
					position = "left",
					size = 40,
				},
				{
					elements = {
						{ id = "repl", size = 1.0 },
					},
					position = "bottom",
					size = 10,
				},
			},
		},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
			  -- dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				-- dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				-- dapui.close({})
			end
		end,
	},
}
-- return {
--   {
--     "mfussenegger/nvim-dap",
--     recommended = true,
--     desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",
--
--     dependencies = {
--       "rcarriga/nvim-dap-ui",
--       -- virtual text for the debugger
--       {
--         "theHamsta/nvim-dap-virtual-text",
--         opts = {},
--       },
--     },
--
--     opts = function()
--       local dap = require("dap")
--       if not dap.adapters["pwa-chrome"] then
--         dap.adapters["pwa-chrome"] = {
--           type = "server",
--           host = "localhost",
--           port = "${port}",
--           executable = {
--             command = "node",
--             args = {
--               require("mason-registry").get_package("js-debug-adapter"):get_install_path()
--                 .. "/js-debug/src/dapDebugServer.js",
--               "${port}",
--             },
--           },
--         }
--       end
--       for _, lang in ipairs({
--         "javascript",
--       }) do
--         dap.configurations[lang] = dap.configurations[lang] or {}
--         table.insert(dap.configurations[lang], {
--           type = "pwa-chrome",
--           request = "launch",
--           name = "Launch Chrome against localhost",
--           url = "http://localhost:3001",
--           webRoot = "${workspaceFolder}",
--           sourceMaps = true,
--           -- protocol = "inspector",
--         })
--
--         table.insert(dap.configurations[lang], {
--           type = "pwa-node",
--           request = "launch",
--           name = "Launch Bun Tests",
--           runtimeExecutable = "bun",
--           runtimeArgs = { "run", "tests" },
--           program = "${file}",
--           cwd = "${workspaceFolder}",
--           sourceMaps = true,
--           protocol = "inspector",
--           console = "integratedTerminal",
--           skipFiles = { "<node_internals>/**" },
--         })
--       end
--
--       require("dap.repl").config = {
--         highlight = true,
--         force_unicode = true,
--         encoding = "utf-8",
--         wrap = false,
--       }
--
--       dap.listeners.before.event_output["remove_ansi"] = function(_, body)
--         if body.output then
--           body.output = body.output:gsub("\27%[[0-9;]*m", "")
--         end
--       end
--     end,
--
--     -- -- stylua: ignore
--     -- keys = {
--     --   { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
--     --   { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
--     --   { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
--     --   { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
--     --   { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
--     --   { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
--     --   { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
--     --   { "<leader>dj", function() require("dap").down() end, desc = "Down" },
--     --   { "<leader>dk", function() require("dap").up() end, desc = "Up" },
--     --   { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
--     --   { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
--     --   { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
--     --   { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
--     --   { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
--     --   { "<leader>ds", function() require("dap").session() end, desc = "Session" },
--     --   { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
--     --   { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
--     -- },
--
--     -- config = function()
--     --   -- load mason-nvim-dap here, after all adapters have been setup
--     --   if LazyVim.has("mason-nvim-dap.nvim") then
--     --     require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
--     --   end
--     --
--     --   vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
--     --
--     --   for name, sign in pairs(LazyVim.config.icons.dap) do
--     --     sign = type(sign) == "table" and sign or { sign }
--     --     vim.fn.sign_define(
--     --       "Dap" .. name,
--     --       { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
--     --     )
--     --   end
--     --
--     --   -- setup dap config by VsCode launch.json file
--     --   local vscode = require("dap.ext.vscode")
--     --   local json = require("plenary.json")
--     --   vscode.json_decode = function(str)
--     --     return vim.json.decode(json.json_strip_comments(str))
--     --   end
--     -- end,
--   },
--
--   {
--     "rcarriga/nvim-dap-ui",
--     dependencies = { "nvim-neotest/nvim-nio" },
--   -- stylua: ignore
--   keys = {
--     { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
--     { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
--   },
--     opts = {
--       layouts = {
--         {
--           elements = {
--             { id = "scopes", size = 0.80 },
--             { id = "watches", size = 0.10 },
--             { id = "breakpoints", size = 0.10 },
--             -- { id = "stacks", size = 0.25 },
--           },
--           position = "left",
--           size = 40,
--         },
--         {
--           elements = {
--             { id = "repl", size = 1.0 },
--           },
--           position = "bottom",
--           size = 10,
--         },
--       },
--     },
--     config = function(_, opts)
--       local dap = require("dap")
--       local dapui = require("dapui")
--       dapui.setup(opts)
--       -- dap.listeners.after.event_initialized["dapui_config"] = function()
--       --   dapui.open({})
--       -- end
--       dap.listeners.before.event_terminated["dapui_config"] = function()
--         dapui.close({})
--       end
--       dap.listeners.before.event_exited["dapui_config"] = function()
--         dapui.close({})
--       end
--     end,
--   },
-- }
-- vim.api.nvim_create_augroup("DapGroup", { clear = true })
--
-- local function navigate(args)
-- 	local buffer = args.buf
--
-- 	local wid = nil
-- 	local win_ids = vim.api.nvim_list_wins() -- Get all window IDs
-- 	for _, win_id in ipairs(win_ids) do
-- 		local win_bufnr = vim.api.nvim_win_get_buf(win_id)
-- 		if win_bufnr == buffer then
-- 			wid = win_id
-- 		end
-- 	end
--
-- 	if wid == nil then
-- 		return
-- 	end
--
-- 	vim.schedule(function()
-- 		if vim.api.nvim_win_is_valid(wid) then
-- 			vim.api.nvim_set_current_win(wid)
-- 		end
-- 	end)
-- end
--
-- local function create_nav_options(name)
-- 	return {
-- 		group = "DapGroup",
-- 		pattern = string.format("*%s*", name),
-- 		callback = navigate,
-- 	}
-- end
--
-- return {
-- 	{
-- 		"mfussenegger/nvim-dap",
-- 		lazy = false,
-- 		config = function()
-- 			local dap = require("dap")
--
-- 			if not dap.adapters["pwa-chrome"] then
-- 				dap.adapters["pwa-chrome"] = {
-- 					type = "server",
-- 					host = "localhost",
-- 					port = "${port}",
-- 					executable = {
-- 						command = "node",
-- 						args = {
-- 							require("mason-registry").get_package("js-debug-adapter"):get_install_path()
-- 								.. "/js-debug/src/dapDebugServer.js",
-- 							"${port}",
-- 						},
-- 					},
-- 				}
-- 			end
--
-- 			-- Add Node.js adapter (using the same js-debug-adapter)
-- 			if not dap.adapters["pwa-node"] then
-- 				dap.adapters["pwa-node"] = {
-- 					type = "server",
-- 					host = "localhost",
-- 					port = "${port}",
-- 					executable = {
-- 						command = "node",
-- 						args = {
-- 							require("mason-registry").get_package("js-debug-adapter"):get_install_path()
-- 								.. "/js-debug/src/dapDebugServer.js",
-- 							"${port}",
-- 						},
-- 					},
-- 				}
-- 			end
--
-- 			for _, lang in ipairs({
-- 				"javascript",
-- 			}) do
-- 				dap.configurations[lang] = dap.configurations[lang] or {}
--
-- 				-- Chrome browser debugging
-- 				table.insert(dap.configurations[lang], {
-- 					type = "pwa-chrome",
-- 					request = "launch",
-- 					name = "Launch Chrome against localhost",
-- 					url = "http://localhost:3001",
-- 					webRoot = "${workspaceFolder}",
-- 					sourceMaps = true,
-- 					-- protocol = "inspector",
-- 				})
--
-- 				-- Node.js debugging
-- 				table.insert(dap.configurations[lang], {
-- 					type = "pwa-node",
-- 					request = "launch",
-- 					name = "Launch Node.js Program",
-- 					program = "${file}",
-- 					cwd = "${workspaceFolder}",
-- 					sourceMaps = true,
-- 					skipFiles = { "<node_internals>/**" },
-- 					resolveSourceMapLocations = {
-- 						"${workspaceFolder}/**",
-- 						"!**/node_modules/**",
-- 					},
-- 				})
--
-- 				-- Node.js debugging with full project context
-- 				table.insert(dap.configurations[lang], {
-- 					type = "pwa-node",
-- 					request = "launch",
-- 					name = "Launch Node.js App (with static files)",
-- 					program = "${file}",
-- 					cwd = "${workspaceFolder}",
-- 					sourceMaps = true,
-- 					skipFiles = { "<node_internals>/**" },
-- 					resolveSourceMapLocations = {
-- 						"${workspaceFolder}/**",
-- 						"!**/node_modules/**",
-- 					},
-- 					runtimeArgs = {
-- 						"--preserve-symlinks",
-- 						"--preserve-symlinks-main",
-- 					},
-- 					env = {
-- 						NODE_ENV = "development",
-- 					},
-- 					console = "integratedTerminal",
-- 					internalConsoleOptions = "neverOpen",
-- 				})
--
-- 				-- Attach to Node.js process
-- 				table.insert(dap.configurations[lang], {
-- 					type = "pwa-node",
-- 					request = "attach",
-- 					name = "Attach to Node.js Process",
-- 					processId = require("dap.utils").pick_process,
-- 					cwd = "${workspaceFolder}",
-- 					sourceMaps = true,
-- 					skipFiles = { "<node_internals>/**" },
-- 				})
-- 			end
--
-- 			dap.set_log_level("DEBUG")
-- 			vim.keymap.set("n", "<F8>", dap.continue, { desc = "Debug: Continue" })
-- 			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
-- 			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
-- 			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
-- 			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
-- 			vim.keymap.set("n", "<leader>B", function()
-- 				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
-- 			end, { desc = "Debug: Set Conditional Breakpoint" })
--
-- 			require("dap.repl").config = {
-- 				highlight = true,
-- 				force_unicode = true,
-- 				encoding = "utf-8",
-- 				wrap = false,
-- 			}
--
-- 			dap.listeners.before.event_output["remove_ansi"] = function(_, body)
-- 				if body.output then
-- 					body.output = body.output:gsub("\27%[[0-9;]*m", "")
-- 				end
-- 			end
-- 		end,
-- 	},
--
-- 	{
-- 		"rcarriga/nvim-dap-ui",
-- 		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
-- 		config = function()
-- 			local dap = require("dap")
-- 			local dapui = require("dapui")
-- 			local function layout(name)
-- 				return {
-- 					elements = {
-- 						{ id = name },
-- 					},
-- 					enter = true,
-- 					size = 120,
-- 					position = "right",
-- 				}
-- 			end
-- 			local name_to_layout = {
-- 				repl = { layout = layout("repl"), index = 0 },
-- 				stacks = { layout = layout("stacks"), index = 0 },
-- 				scopes = { layout = layout("scopes"), index = 0 },
-- 				console = { layout = layout("console"), index = 0 },
-- 				watches = { layout = layout("watches"), index = 0 },
-- 				breakpoints = { layout = layout("breakpoints"), index = 0 },
-- 			}
-- 			local layouts = {}
--
-- 			for name, config in pairs(name_to_layout) do
-- 				table.insert(layouts, config.layout)
-- 				name_to_layout[name].index = #layouts
-- 			end
--
-- 			local function toggle_debug_ui(name)
-- 				dapui.close()
-- 				local layout_config = name_to_layout[name]
--
-- 				if layout_config == nil then
-- 					error(string.format("bad name: %s", name))
-- 				end
--
-- 				dapui.toggle(layout_config.index)
-- 			end
--
-- 			vim.keymap.set("n", "<leader>dr", function()
-- 				toggle_debug_ui("repl")
-- 			end, { desc = "Debug: toggle repl ui" })
-- 			vim.keymap.set("n", "<leader>ds", function()
-- 				toggle_debug_ui("stacks")
-- 			end, { desc = "Debug: toggle stacks ui" })
-- 			vim.keymap.set("n", "<leader>dw", function()
-- 				toggle_debug_ui("watches")
-- 			end, { desc = "Debug: toggle watches ui" })
-- 			vim.keymap.set("n", "<leader>db", function()
-- 				toggle_debug_ui("breakpoints")
-- 			end, { desc = "Debug: toggle breakpoints ui" })
-- 			vim.keymap.set("n", "<leader>dS", function()
-- 				toggle_debug_ui("scopes")
-- 			end, { desc = "Debug: toggle scopes ui" })
-- 			vim.keymap.set("n", "<leader>dc", function()
-- 				toggle_debug_ui("console")
-- 			end, { desc = "Debug: toggle console ui" })
--
-- 			vim.api.nvim_create_autocmd("BufEnter", {
-- 				group = "DapGroup",
-- 				pattern = "*dap-repl*",
-- 				callback = function()
-- 					vim.wo.wrap = true
-- 				end,
-- 			})
--
-- 			vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("dap-repl"))
-- 			vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("DAP Watches"))
--
-- 			dapui.setup({
-- 				layouts = layouts,
-- 				enter = true,
-- 			})
--
-- 			-- dap.listeners.before.event_terminated.dapui_config = function()
-- 			-- 	dapui.close()
-- 			-- end
-- 			-- dap.listeners.before.event_exited.dapui_config = function()
-- 			-- 	dapui.close()
-- 			-- end
--
-- 			dap.listeners.after.event_output.dapui_config = function(_, body)
-- 				if body.category == "console" then
-- 					dapui.eval(body.output) -- Sends stdout/stderr to Console
-- 				end
-- 			end
-- 		end,
-- 	},
--
-- 	-- {
-- 	-- 	"jay-babu/mason-nvim-dap.nvim",
-- 	-- 	dependencies = {
-- 	-- 		"williamboman/mason.nvim",
-- 	-- 		"mfussenegger/nvim-dap",
-- 	-- 		"neovim/nvim-lspconfig",
-- 	-- 	},
-- 	-- 	config = function()
-- 	-- 		require("mason-nvim-dap").setup({
-- 	-- 			ensure_installed = {
-- 	-- 				"delve",
-- 	-- 				"js-debug-adapter",
-- 	-- 			},
-- 	-- 			automatic_installation = true,
-- 	-- 			handlers = {
-- 	-- 				function(config)
-- 	-- 					require("mason-nvim-dap").default_setup(config)
-- 	-- 				end,
-- 	-- 				delve = function(config)
-- 	-- 					table.insert(config.configurations, 1, {
-- 	-- 						args = function()
-- 	-- 							return vim.split(vim.fn.input("args> "), " ")
-- 	-- 						end,
-- 	-- 						type = "delve",
-- 	-- 						name = "file",
-- 	-- 						request = "launch",
-- 	-- 						program = "${file}",
-- 	-- 						outputMode = "remote",
-- 	-- 					})
-- 	-- 					table.insert(config.configurations, 1, {
-- 	-- 						args = function()
-- 	-- 							return vim.split(vim.fn.input("args> "), " ")
-- 	-- 						end,
-- 	-- 						type = "delve",
-- 	-- 						name = "file args",
-- 	-- 						request = "launch",
-- 	-- 						program = "${file}",
-- 	-- 						outputMode = "remote",
-- 	-- 					})
-- 	-- 					require("mason-nvim-dap").default_setup(config)
-- 	-- 				end,
-- 	-- 			},
-- 	-- 		})
-- 	-- 	end,
-- 	-- },
-- }
