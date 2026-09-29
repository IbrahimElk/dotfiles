-- See `https://github.com/benlubas/molten-nvim/blob/main/docs/Notebook-Setup.md`

-- Provide a command to create a blank new Python notebook
-- note: the metadata is needed for Jupytext to understand how to parse the notebook.
-- if you use another language than Python, you should change it in the template.
local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
      "file_extension": ".py",
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3"
     }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

local function new_notebook(filename)
  local path = filename .. ".ipynb"
  local file = io.open(path, "w")
  if file then
    file:write(default_notebook)
    file:close()
    vim.cmd("edit " .. path)
  else
    print("Error: Could not open new notebook file for writing.")
  end
end

vim.api.nvim_create_user_command('NewNotebook', function(opts)
  new_notebook(opts.args)
end, {
  nargs = 1,
  complete = 'file'
})

local converting = false
local function convert_ipynb_to_py(ipynb_file)
  converting = true
  local py_file = ipynb_file:gsub("%.ipynb$", ".py")
  vim.fn.system({ "jupytext", "--to", "py:percent", ipynb_file, "--output", py_file })
  converting = false
end

local function convert_py_to_ipynb(py_file)
  converting = true
  local ipynb_file = py_file:gsub("%.py$", ".ipynb")
  vim.fn.system({ "jupytext", "--to", "ipynb", py_file, "--output", ipynb_file })
  converting = false
end

-- 1) When opening an ipynb file, convert it to a py file
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.ipynb",
  callback = function()
    if converting then
      return
    end
    -- print("ipynb -> py")
    local ipynb_file = vim.fn.expand("%:p")
    local py_file = ipynb_file:gsub("%.ipynb$", ".py")
    convert_ipynb_to_py(ipynb_file)
    -- Reload the buffer to prevent warnings
    vim.cmd("checktime")
  end,
})

-- 2) When saving a Python file, sync the corresponding ipynb file
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.py",
  callback = function()
    if converting then
      return
    end
    -- print("py -> ipynb")
    local py_file = vim.fn.expand("%:p")
    local ipynb_file = py_file:gsub("%.py$", ".ipynb")
    -- Check if corresponding .ipynb file exists
    if vim.fn.filereadable(ipynb_file) == 1 then
      convert_py_to_ipynb(py_file)
      -- Reload the buffer to prevent warnings
      vim.cmd("checktime")
    end

  end,
})

-- 3) When saving an ipynb file, sync the corresponding Python file
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.ipynb",
  callback = function()
    if converting then
      return
    end
    -- print("ipynb -> py")
    local ipynb_file = vim.fn.expand("%:p")
    convert_ipynb_to_py(ipynb_file)
    -- Reload the buffer to prevent warnings
    vim.cmd("checktime")
  end,
})


return {
  -- {
  --   'GCBallesteros/jupytext.nvim',
  --   opts = {
  --     format = "py",
  --     sync_patterns = "py",
  --     filetype = "py"
  --   },
  -- },
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local quarto = require("quarto")
      quarto.setup({
        lspFeatures = {
          -- NOTE: put whatever languages you want here:
          languages = { "python", "rust" },
          chunks = "all",
        },
        codeRunner = {
          enabled = true,
          default_method = "molten",
        },
      })

      local runner = require("quarto.runner")
      vim.keymap.set("n", "<localleader>rl", runner.run_line,
        { desc = "run line", silent = true })

      vim.keymap.set("v", "<localleader>rn", runner.run_range,
        { desc = "run visual range", silent = true })

      -- vim.keymap.set("n", "<localleader>rc", runner.run_cell,
      --   { desc = "run cell", silent = true })

      -- vim.keymap.set("n", "<localleader>ra", runner.run_above,
      --   { desc = "run cell and above", silent = true })

      -- vim.keymap.set("n", "<localleader>rA", runner.run_all,
      --   { desc = "run all cells", silent = true })


      -- vim.keymap.set("n", "<localleader>RA", function()
      --   runner.run_all(true)
      -- end, { desc = "run all cells of all languages", silent = true })

    end,
  },
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      -- this is an example, not a default.
      -- Please see the readme for more configuration options
      vim.g.molten_output_win_max_height = 12
      vim.g.molten_auto_open_output = false
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true

      vim.keymap.set("n", "<localleader>me", ":MoltenEvaluateOperator<CR>",
        { desc = "evaluate operator", silent = true })

      vim.keymap.set("n", "<localleader>mw", ":noautocmd MoltenEnterOutput<CR>",
        { desc = "open output window", silent = true })

      -- vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>",
      --   { desc = "re-eval cell", silent = true })

      vim.keymap.set("v", "<localleader>mv", ":<C-u>MoltenEvaluateVisual<CR>gv",
        { desc = "execute visual selection", silent = true })

      -- vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>",
      --   { desc = "close output window", silent = true })
      --
      -- vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>",
      --   { desc = "delete Molten cell", silent = true })

      vim.keymap.set("n", "<localleader>mb", ":MoltenOpenInBrowser<CR>",
        { desc = "open output in browser", silent = true })

    end,
  }
}
