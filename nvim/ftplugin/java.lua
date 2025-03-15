-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local home = os.getenv('HOME')
local jdtls = require('jdtls')

local filetypes = { 'java' }
-- File types that signify a Java project's root directory. This will be
-- used by eclipse to determine what constitutes a workspace
local root_markers = { 'gradlew', 'mvnw', '.git', 'pom.xml', 'build.gradle' }
local root_dir = function()
    return jdtls.setup.find_root(root_markers)
end

local mason_packages = home .. "/.local/share/nvim/mason/packages"
local mason_share = home .. "/.local/share/nvim/mason/share"
local jdtls_package = mason_packages .. "/jdtls"
local google_style = mason_share .. "/jdtls/eclipse-java-google-style.xml"
local jdtls_jar = vim.fn.glob(jdtls_package .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local bundles = {
    vim.fn.glob(home .. '/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar', true)
};
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. '/.local/share/nvim/mason/share/java-test/*.jar', true), '\n'))
local jdtls_config_path = jdtls_package .. "/config_linux"
local lombok_jar = jdtls_package .. "/lombok.jar"
-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.
local workspace_folder = home .. "/.cache/jdtls/workspace/" .. vim.fn.fnamemodify(root_dir(), ":p:h:t")

-- The on_attach function is used to set key maps after the language server
-- attaches to the current buffer
local jdtls_on_attach = function(_, bufnr)
    local jdtls_dap = require("jdtls.dap")
    require('custom.config.lsp_keymaps').base_mapping(bufnr)
    -- Helper function for creating keymaps
    local nmap = function(rhs, lhs, bufopts, desc)
        bufopts.desc = desc
        vim.keymap.set("n", rhs, lhs, bufopts)
    end
    -- Regular Neovim LSP client keymappings
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    -- Java extensions provided by jdtls
    nmap('<C-i>', jdtls.organize_imports, bufopts, "Organize imports")
    nmap('<leader>ev', jdtls.extract_variable, bufopts, "Extract variable")
    nmap('<leader>ec', jdtls.extract_constant, bufopts, "Extract constant")
    vim.keymap.set('v', '<leader>em', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
        { noremap = true, silent = true, buffer = bufnr, desc = "Extract method" })
    nmap('<F5>', function()
            jdtls_dap.setup_dap_main_class_configs({ on_ready = function() require('dap').continue() end })
            vim.lsp.codelens.refresh()
        end,
        bufopts, "Find eligible classes then start debug")
    -- setup debug adapter: find main methods & code hot swap
    jdtls.setup_dap({ hotcodereplace = "auto" })
end

local jdtls_config = function(caps)
    return {
        settings = {
            java = {
                format = {
                    settings = {
                        url = google_style,
                        profile = "GoogleStyle",
                    }
                },
                signatureHelp = { enabled = true },
                contentProvider = { preferred = 'fernflower' }, -- Use fernflower to decompile library code
                -- Specify any completion options
                completion = {
                    favoriteStaticMembers = {
                        "org.junit.jupiter.api.Assertions.*",
                        "java.util.Objects.requireNonNull",
                        "java.util.Objects.requireNonNullElse",
                        "org.mockito.Mockito.*"
                    },
                    filteredTypes = {
                        "com.sun.*",
                        "io.micrometer.shaded.*",
                        "java.awt.*",
                        "jdk.*", "sun.*",
                    },
                },
                import = {
                    gradle = { enabled = true },
                    maven = { enabled = true },
                    exclusions = {
                        "**/.metadata/**",
                        "**/archetype-resources/**",
                        "**/META-INF/maven/**",
                        "/**/test/**"
                    }
                },
                -- Specify any options for organizing imports
                sources = {
                    organizeImports = {
                        starThreshold = 9999,
                        staticStarThreshold = 9999,
                    },
                },
                -- How code generation should act
                codeGeneration = {
                    toString = {
                        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                    },
                    hashCodeEquals = {
                        useJava7Objects = true,
                    },
                    useBlocks = true,
                },
                configuration = {
                    runtimes = {
                        {
                            name = "JavaSE-21",
                            path = "/usr/lib/jvm/java-21-openjdk",
                            javadoc = "/usr/share/doc/java21-openjdk",
                            sources = "/usr/lib/jvm/java-21-openjdk/lib/src.zip",
                            default = true,
                        },
                        {
                            name = "JavaSE-17",
                            path = "/usr/lib/jvm/java-17-openjdk",
                            javadoc = "/usr/share/doc/java17-openjdk",
                            sources = "/usr/lib/jvm/java-17-openjdk/lib/src.zip",
                        },
                        {
                            name = "JavaSE-11",
                            path = "/usr/lib/jvm/java-11-openjdk",
                            javadoc = "/usr/share/doc/java11-openjdk",
                            sources = "/usr/lib/jvm/java-11-openjdk/lib/src.zip",
                        },
                    },
                    maven = {
                        userSettings = nil,
                        globalSettings = home .. "/.config/maven/settings.xml",
                    }
                }
            }
        },
        flags = {
            debounce_text_changes = 80,
        },
        filetypes = filetypes,
        on_attach = jdtls_on_attach, -- We pass our on_attach keybindings to the configuration map
        root_dir = root_dir(),       -- Set the root directory to our found root_marker
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        init_options = {
            -- debug adapter
            bundles = bundles
        },
        capabilities = caps,
        -- cmd is the command that starts the language server. Whatever is placed
        -- here is what is passed to the command line to execute jdtls.
        -- Note that eclipse.jdt.ls must be started with a Java version of 21 or higher
        -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
        -- for the full list of options
        cmd = {
            '/usr/lib/jvm/java-21-openjdk/bin/java',
            '-Declipse.application=org.eclipse.jdt.ls.core.id1',
            '-Dosgi.bundles.defaultStartLevel=4',
            '-Declipse.product=org.eclipse.jdt.ls.core.product',
            '-Dlog.protocol=true',
            '-Dlog.level=ALL',
            '-Xmx4g',
            '-javaagent:' .. lombok_jar,
            '--add-modules=ALL-SYSTEM',
            '--add-opens', 'java.base/java.util=ALL-UNNAMED',
            '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
            '-jar', jdtls_jar,
            '-configuration', jdtls_config_path,

            -- Use the workspace_folder defined above to store data for this project
            '-data', workspace_folder,
        },
    }
end

local config = jdtls_config(capabilities)
require('jdtls').start_or_attach(config)
