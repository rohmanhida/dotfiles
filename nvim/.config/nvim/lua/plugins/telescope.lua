return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require 'telescope.builtin'
      local actions = require('telescope.actions')

      require('telescope').setup {
        defaults = {
          mappings = {
            i = { -- Insert mode
              ["<C-u>"] = actions.move_selection_previous, -- Move up
              ["<C-d>"] = actions.move_selection_next,     -- Move down
            },
            n = { -- Normal mode
              ["<C-u>"] = actions.move_selection_previous,
              ["<C-d>"] = actions.move_selection_next,
            },
          },
        },
      }

      vim.keymap.set('n', '<leader>gr', builtin.lsp_references, { desc = '[G]oto [R]eferences' })
      vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { desc = '[D]ocument [S]ymbol' })
      vim.keymap.set('n', '<leader>ws', builtin.lsp_dynamic_workspace_symbols, { desc = '[W]orkspace [S]ymbol' })
      vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<C-f>', builtin.live_grep, { desc = '[F]ind [G]rep' })
      vim.keymap.set('n', '<leader>gd', builtin.lsp_definitions, { desc = '[G]oto [D]efinition' })
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = '[E]rror' })
    end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require('telescope').load_extension 'ui-select'
    end,
  },
  {
    'nvim-telescope/telescope-symbols.nvim',
  }
}
