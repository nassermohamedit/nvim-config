local home = os.getenv("HOME")
local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls/"
local workspace_path = home .. "/.local/share/nvim/jdtls-workspace"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name

local status, jdtls = pcall(require, "jdtls")

if not status then
	vim.print("java.lua: Failed to require jdtls")
	return
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.level=ALL",
		"-Xmx1G",
		"--add-modules=ALL-SYSTEM",
		"--add-opens=java.base/java.util=ALL-UNNAMED",
		"--add-opens=java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. jdtls_path .. "/lombok.jar",
		"-jar",
		jdtls_path .. "/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",
		"-configuration",
		jdtls_path .. "/config_linux/",
		"-data",
		workspace_dir,
	},
	init_options = {},
	root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
	settings = {
		java = {
			eclipse = {
				downloadSources = true,
			},
			signatureHelp = { enabled = true },
			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = {
					{
						name = "JavaSE-21",
						path = "/usr/lib/jvm/jdk-21-oracle-x64/",
					},
					{
						name = "JavaSE-17",
						path = "/usr/lib/jvm/java-17-openjdk-amd64/",
					},
					{
						name = "JavaSE-23",
						path = "/usr/lib/jvm/jdk-23-oracle-x64/",
					},
				},
			},
			extendedClientCapabilities = extendedClientCapabilities,
			maven = {
				downloadSources = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = "none", -- literals, all, none
				},
			},
			format = {
				enabled = false,
			},
		},
	},
}

bundles = {
    vim.fn.glob(home .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1),
}

vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/vscode-java-test/server/*.jar", 1), "\n"))
config["init_options"] = {
	bundles = bundles,
}

require("jdtls").start_or_attach(config)

local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", "$$", "$a", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
vim.api.nvim_set_keymap("n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
vim.api.nvim_set_keymap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
vim.api.nvim_set_keymap("n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
vim.keymap.set("n", "<leader>co", "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = "Organize Imports" })
vim.keymap.set("n", "<leader>crv", "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = "Extract Variable" })
vim.keymap.set(
	"v",
	"<leader>crv",
	"<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
	{ desc = "Extract Variable" }
)
vim.keymap.set("n", "<leader>crc", "<Cmd>lua require('jdtls').extract_constant()<CR>", { desc = "Extract Constant" })
vim.keymap.set(
	"v",
	"<leader>crc",
	"<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
	{ desc = "Extract Constant" }
)
vim.keymap.set(
	"v",
	"<leader>crm",
	"<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
	{ desc = "Extract Method" }
)
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
-- Organize Imports
-- Organize Imports (Alt + o)
vim.api.nvim_set_keymap(
	"n",
	"<A-O>",
	"<Cmd>lua require'jdtls'.organize_imports()<CR>",
	{ noremap = true, silent = true }
)

-- Extract Variable
vim.api.nvim_set_keymap(
	"n",
	"crv",
	"<Cmd>lua require('jdtls').extract_variable()<CR>",
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"v",
	"crv",
	"<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
	{ noremap = true, silent = true }
)

-- Extract Constant
vim.api.nvim_set_keymap(
	"n",
	"crc",
	"<Cmd>lua require('jdtls').extract_constant()<CR>",
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"v",
	"crc",
	"<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
	{ noremap = true, silent = true }
)

-- Extract Method
vim.api.nvim_set_keymap(
	"v",
	"crm",
	"<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
	{ noremap = true, silent = true }
)

-- Test Class and Nearest Method (for nvim-dap)
vim.api.nvim_set_keymap(
	"n",
	"<leader>df",
	"<Cmd>lua require'jdtls'.test_class()<CR>",
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>dn",
	"<Cmd>lua require'jdtls'.test_nearest_method()<CR>",
	{ noremap = true, silent = true }
)


local diagnostics_visible = true

local function toggle_diagnostics()
    print("Switching diagnostics")
    diagnostics_visible = not diagnostics_visible
    if diagnostics_visible then
        vim.diagnostic.enable(true);
    else
        vim.diagnostic.enable(false);
    end
end

vim.keymap.set(
	"n",
	"<leader>z",
    toggle_diagnostics
)
vim.diagnostic.enable(false);

require("camellia").setup()

vim.api.nvim_set_keymap(
	"n",
	"<leader><leader>",
	"<Cmd>lua require'camellia'.run_main()<CR>",
	{ noremap = true, silent = true }
)
