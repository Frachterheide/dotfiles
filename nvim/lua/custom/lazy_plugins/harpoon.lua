return {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require('harpoon'):setup()
    end,
    keys = {
        { "<leader>a", function() require("harpoon"):list():add() end,                                    desc = '[J]ab current file' },
        { "<C-e>",     function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = '[E]nter harpoon quick menu' },
        { "<C-1>",     function() require("harpoon"):list():select(1) end },
        { "<C-2>",     function() require("harpoon"):list():select(2) end },
        { "<C-3>",     function() require("harpoon"):list():select(3) end },
        { "<C-4>",     function() require("harpoon"):list():select(4) end },
        { "<C-S-P>",   function() require("harpoon"):list():prev() end },
        { "<C-S-N>",   function() require("harpoon"):list():next() end },

        -- basic telescope configuration
        { "<C-h>", function()
            local harpoon_files = require("harpoon"):list()
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = require("telescope.config").values.file_previewer({}),
                sorter = require("telescope.config").values.generic_sorter({}),
            }):find()
        end,
            { desc = "Open harpoon window" } }
    },
}
