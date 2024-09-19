-- debug.lua
return {
  -- NOTE: Yes, you can install new plugins here!
  "mfussenegger/nvim-dap",
  lazy = true,
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    -- async io api and primitives for Neovim Core
    "nvim-neotest/nvim-nio",
    -- Installs the debug adapters for you
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      -- automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'javadbg',
        'javatest',
        'kotlin',
      },
    }

    dap.adapters.php = {
      type = 'executable',
      command = 'node',
      args = { '${HOME}/.local/bin/php-debug-adapter' }
    }

    dap.configurations.php = {
      type = 'php',
      request = 'launch',
      name = 'Listen for Xdebug',
      port = 9000,
    }

    dap.adapters.kotlin = {
      type = "executable",
      command = "kotlin-debug-adapter",
      options = { auto_continue_if_many_stopped = false },
    }

    dap.configurations.kotlin = {
      {
        type = "kotlin",
        request = "launch",
        name = "This file",
        mainClass = function()
          local root = vim.fs.find("src", { path = vim.fn.getcwd(), upward = true, stop = vim.env.HOME })[1] or ""
          local fname = vim.api.nvim_buf_get_name(0)
          return fname:gsub(root, ""):gsub("main/kotlin/", ""):gsub(".kt", "Kt"):gsub("/", ".").sub(2, -1)
        end,
        projectRoot = "${workspaceFolder}",
        jsonLogFile = "",
        enableJsonLogging = false,
      },
      {
        --Use this for unit tests
        -- First, run
        -- ./gradlew --info cleanTest test --debug-jvm
        -- then attach the debugger to it
        type = "kotlin",
        request = "attach",
        name = "Attach to debugging session",
        port = 5005,
        projectRoot = vim.fn.getcwd,
        hostName = "localhost",
        timeout = 2000,
      },
    }


    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        element = 'repl',
        enabled = true,
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
