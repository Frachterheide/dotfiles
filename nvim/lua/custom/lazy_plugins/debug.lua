-- debug.lua
return {
  "mfussenegger/nvim-dap",
  lazy = true,
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
      -- a best effort
      -- automatic_setup = true,
      handlers = {},
      automatic_installation = true,
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'javadbg',
        'kotlin',
        'php'
      }
    }
    dap.adapters.lldb = {
      type = 'executable',
      command = 'lldb-dap',
      name = 'lldb'
    }
    -- default config for c, cpp
    -- more info: https://github.com/llvm/llvm-project/tree/main/lldb/tools/lldb-dap#configuration-settings-reference
    dap.configurations.cpp = {
      name = 'Launch',
      type = 'lldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {}
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp
    dap.configurations.rust = {
      initCommands = function()
        -- lookup pretty printer python module
        local rustc_sysroot = vim.fn.trim(vim.fn.system 'rustc --print sysroot')
        assert(
          vim.v.shell_error == 0,
          'Failed to get rust sysroot using `rust --print sysroot`: ' .. rustc_sysroot
        )
        local script_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py'
        local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'
        -- check support :
        -- lldb --batch -o 'help command script import'
        -- lldb --batch -o 'help command source'
        return {
          ([[!command script import '%s']]):format(script_file),
          ([[command source '%s']]):format(commands_file),
        }
      end
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
  end
}
