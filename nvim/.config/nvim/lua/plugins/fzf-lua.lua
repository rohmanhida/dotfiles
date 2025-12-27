return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- function to be called by keymaps
    local function grep_to_qf()
      require("fzf-lua").live_grep_glob({
        actions = {
          ["default"] = require("fzf-lua").actions.file_edit_qf,
        },
      })
    end

    -- keymaps group
    local wk = require("which-key")
    wk.add({
      { "<leader>f", group = "Files", icon = " " },
      { "<leader>d", group = "Document", icon = "󰈙 " },
      { "<leader>w", group = "Workspace", icon = " " },
    })

    -- open files in current directory
    vim.keymap.set("n", "<leader>ff", function()
      require("fzf-lua").files()
    end, { desc = "Go to [F]iles" })

    -- last opened files
    vim.keymap.set("n", "<leader>fl", function()
      require("fzf-lua").oldfiles()
    end, { desc = "[L]ast Opened" })

    -- quickfix
    vim.keymap.set("n", "<leader>fq", grep_to_qf, { desc = "[Q]uickfix" })

    -- treesitter objects
    vim.keymap.set("n", "<leader>ft", function()
      require("fzf-lua").treesitter()
    end, { desc = "[T]tresitter" })

    -- live grep
    vim.keymap.set("n", "<leader>fg", function()
      require("fzf-lua").live_grep()
    end, { desc = "live [G]rep" })

    -- document symbols
    vim.keymap.set("n", "<leader>ds", function()
      require("fzf-lua").lsp_document_symbols()
    end, { desc = "[D]ocument [S]ymbol" })

    -- go to definition
    vim.keymap.set("n", "<leader>dd", function()
      require("fzf-lua").lsp_definitions()
    end, { desc = "[D]ocument [D]efinition" })

    -- document diagnostics
    vim.keymap.set("n", "<leader>de", function()
      require("fzf-lua").diagnostics_document()
    end, { desc = "[D]ocument [E]rrors" })

    -- go to references
    vim.keymap.set("n", "<leader>dr", function()
      require("fzf-lua").lsp_references()
    end, { desc = "[D]ocument [R]eferences" })

    -- code actions
    vim.keymap.set("n", "<leader>dc", function()
      require("fzf-lua").lsp_code_actions()
    end, { desc = "[C]ode Actions" })

    -- workspace symbols
    vim.keymap.set("n", "<leader>ws", function()
      require("fzf-lua").lsp_workspace_symbols()
    end, { desc = "[W]orkspace [S]ymbols" })

    -- workspace diagnostics
    vim.keymap.set("n", "<leader>we", function()
      require("fzf-lua").diagnostics_workspace()
    end, { desc = "[W]orkspace [E]rrors" })
  end,
}
