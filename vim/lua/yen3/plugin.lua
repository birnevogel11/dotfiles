local config_util = require('util.config')

local M = {}

function M.packer()
  local check_install = function()
    local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
      vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    end
  end

  check_install()

  vim.cmd [[ packadd packer.nvim ]]

  return require("packer").startup(
    function(use)
      use "wbthomason/packer.nvim"

      -- Color scheme
      use "tjdevries/colorbuddy.nvim"

      -- Apperence
      use 'mkitt/tabline.vim'
      use 'wsdjeg/vim-todo'
      use {'majutsushi/tagbar', requires = 'tenfyzhong/tagbar-makefile.vim'}
      use 'tjdevries/train.nvim'
      use 'kyazdani42/nvim-web-devicons'
      use 'rcarriga/nvim-notify'

      -- Status line
      use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
      }

      -- Tree sitter
      use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
      use {'nvim-treesitter/nvim-treesitter-textobjects'}
      use {'nvim-treesitter/playground', run = ':TSInstall query'}
      -- use {'nvim-treesitter/nvim-treesitter-refactor'}

      -- Generic
      config_util.set_variables {
        polyglot_disabled = {'cpp', 'c', 'python', 'haskell', 'tex'}
      }
      use 'sheerun/vim-polyglot'
      use 'aymericbeaumet/vim-symlink'
      use 'embear/vim-localvimrc'
      use {'vim-test/vim-test', requires = 'benmills/vimux'}
      use 'kamykn/spelunker.vim'
      use 'farmergreg/vim-lastplace'
      if vim.fn.executable('xkbswitch') == 1 then
        use 'rlue/vim-barbaric'
      end
      use 'norcalli/nvim-colorizer.lua'

      -- File browser
      use 'voldikss/vim-floaterm'
      use 'ptzz/lf.vim'

      -- Edit
      use 'MarcWeber/vim-addon-mw-utils'
      use 'tpope/vim-abolish'
      use 'tpope/vim-endwise'
      use '9mm/vim-closer'
      use 'tpope/vim-rhubarb'
      use 'tpope/vim-sensible'
      use 'tpope/vim-speeddating'
      use 'tpope/vim-surround'
      use 'Yggdroot/indentLine'
      -- use 'junegunn/vim-easy-align'

      use 'scrooloose/nerdcommenter'
      use 'Raimondi/delimitMate'
      use 'michaeljsmith/vim-indent-object'
      use 'ntpeters/vim-better-whitespace'

      use {'kevinhwang91/nvim-bqf', branch = "main"}
      use 'google/vim-searchindex'

      use 'anufrievroman/vim-angry-reviewer'

      -- Bitbake
      use {'kergoth/vim-bitbake', ft = 'bitbake'}

      -- C and CPP
      use {'rhysd/vim-clang-format', ft = {'c', 'cpp'}}

      -- CSV
      use {'chrisbra/csv.vim', ft = 'csv'}

      -- Go
      use {'fatih/vim-go', ft = 'go'}

      -- Haskell
      use {'yen3/haskell-vim', ft = 'haskell', branch = 'record-color'}
      -- use {'alx741/vim-hindent', ft = 'haskell'}
      use {'alx741/vim-stylishask', ft = 'haskell'}
      use {'ndmitchell/ghcid', ft = 'haskell', rtp = 'plugins/nvim'}
      use {'monkoose/fzf-hoogle.vim',
           ft = {'haskell'}, requires = { "junegunn/fzf.vim" }
      }

      -- LaTeX
      use {'lervag/vimtex', ft = 'tex'}

      -- Rust
      use {'rust-lang/rust.vim', ft = 'rust'}
      use {'Chiel92/vim-autoformat', ft = 'rust'}

      -- Markdown
      use {'plasticboy/vim-markdown', ft = 'markdown'}
      use {'iamcco/markdown-preview.nvim', ft = 'markdown',
           run = 'cd app && yarn install'}

      -- Python
      use {'vim-python/python-syntax', ft = 'python'}
      use {'psf/black', ft = 'python'}
      use {'jeetsukumaran/vim-pythonsense', ft = 'python'}
      if vim.fn.executable('stack') == 1 then
        use {
          'https://gitlab.com/yen3/pyimport-sort-cdm.git',
          ft = 'python', run = 'stack install'
        }
      end

      -- TOML
      use {'cespare/vim-toml', ft = {'toml'}}

      -- Rescript
      -- use {'rescript-lang/vim-rescript'}

      -- JavaScript/TypeScript
      local js_types = {'javascript', 'typescript', 'typescriptreact'}
      use {'alvan/vim-closetag', ft = js_types}
      use {'pangloss/vim-javascript', ft = js_types}
      use {'mxw/vim-jsx', ft = js_types}
      use {'othree/yajs.vim', ft = js_types}
      use {'HerringtonDarkholme/yats.vim', ft = js_types, run = 'rm -rf UltiSnips'}
      use {'turbio/bracey.vim', ft = js_types, run = 'npm install --prefix server'}
      use {'prettier/vim-prettier', ft = js_types}

      -- Git
      use {'tpope/vim-fugitive'}
      use {'tpope/vim-dispatch'}
      use {'lambdalisue/gina.vim'}
      use {'junegunn/gv.vim'}
      use {'lewis6991/gitsigns.nvim', branch = "main", requires = {'nvim-lua/plenary.nvim'}}
      use {'TimUntersberger/neogit', requires = {'sindrets/diffview.nvim', 'nvim-lua/plenary.nvim'}}

      -- Github
      use {'skanehira/gh.vim'}
      use {'pwntester/octo.nvim'}

      -- Tmux
      use 'christoomey/vim-tmux-navigator'
      use 'tmux-plugins/vim-tmux-focus-events'

      -- Search
      use {"junegunn/fzf.vim",
        requires = {
          {"junegunn/fzf", run = "./install --all"}
        }
      }
      use {'nvim-telescope/telescope.nvim',
        requires = {
          'nvim-lua/popup.nvim',
          'nvim-lua/plenary.nvim',
          'nvim-telescope/telescope-fzy-native.nvim',
          'nvim-telescope/telescope-github.nvim',
          {'nvim-telescope/telescope-frecency.nvim', requires = {'tami5/sql.nvim'}},
        }
      }

      -- Snippet
      use 'hrsh7th/cmp-vsnip'
      use 'hrsh7th/vim-vsnip'
      use 'rafamadriz/friendly-snippets'

      -- LSP
      use {'neovim/nvim-lspconfig',
        requires = {
          {'tami5/lspsaga.nvim', branch = "nvim51"},
          {'ray-x/lsp_signature.nvim'},
          {'ray-x/guihua.lua', run = 'cd lua/fzy && make'},
        }
      }
      use {'hrsh7th/nvim-cmp', branch = "main",
        requires = {
          {'andersevenrud/compe-tmux', branch = "cmp"},
          {'hrsh7th/cmp-nvim-lsp', branch = "main"},
          {'hrsh7th/cmp-buffer', branch = "main"},
          {'hrsh7th/cmp-path', branch = "main"},
          {'onsails/lspkind-nvim', branch = "master"},
        }
      }

      -- Diagnostics
      -- use 'dense-analysis/ale'
      use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
      }
      use { 'jose-elias-alvarez/null-ls.nvim', branch = "main" }

      -- ref: https://github.com/petobens/dotfiles/blob/master/vim/init.vim#L190
      -- This basically fixes visual block pasting
      -- https://github.com/neovim/neovim/issues/1822#issuecomment-233152833
      use {'bfredl/nvim-miniyank'}
    end)
end


function M.vim_better_whitespace()
  config_util.set_variables {
    better_whitespace_enabled = 1,
    strip_whitespace_on_save = 1,
    strip_whitelines_at_eof = 1,
    show_spaces_that_precede_tabs = 1,
    strip_whitespace_confirm = 0,
    strip_max_file_size = 1000,
  }
end

function M.nerd_commenter()
  config_util.set_variables {
    NERDSpaceDelims = 1,  -- Leave space after comment delimiter
    NERDCreateDefaultMappings = 0,  -- Disable default mappings
    NERDCustomDelimiters = { python = { left = '#' } }, -- Fix python spacing
  }

  local keymap = function(leader_key, value)
    config_util.create_keymap('', '<leader>'..leader_key, '<Plug>'..value, {silent=true})
  end

  keymap('cc', 'NERDCommenterComment')
  keymap('cu', 'NERDCommenterUncomment')
  keymap('ce', 'NERDCommenterToEOL')
  keymap('ac', 'NERDCommenterAppend')
end

function M.vim_markdown()
  config_util.set_variables {
    vim_markdown_folding_disabled = 1,
    vim_markdown_folding_style_pythonic = 1,
    vim_markdown_override_foldtext = 0,
    vim_markdown_new_list_item_indent = 0,
    vim_markdown_auto_insert_bullets = 1,
    vim_markdown_conceal = 0,
    vim_markdown_conceal_code_blocks = 0,
  }
end

function M.vim_localvimrc()
  config_util.set_variables { localvimrc_ask = 0, localvimrc_sandbox = 0, }
end

function M.indentline()
  config_util.set_variables {
    indentLine_char = '│',
    indentLine_faster = 1
  }
end

function M.spelunker_vim()
  config_util.set_variables { enable_spelunker_vim = 0, }
end

function M.train_nvim()
  config_util.map_n('<leader>jj', ':TrainTextObj<cr>')
end

function M.tagbar()
  config_util.set_variables {
    tagbar_map_openfold = {'zo', 'l'},
    tagbar_map_closeallfolds = 'zm',
    tagbar_map_openallfolds = 'zr',

    tagbar_width = 40,
    tagbar_autofocus = 1,                 -- Keep focus on tagbar window
    tagbar_sort = 1,                      -- Sort tags alphabetically
    tagbar_compact = 1,
    tagbar_indent = 1,
    tagbar_autopreview = 0,               -- Don't autopreview, enable it with P
    tagbar_previewwin_pos = 'belowright',

    tagbar_type_python = {
      kinds = {
        'i:modules:1:0',
        'c:classes',
        'f:functions',
        'm:members',
        'v:variables:0:0',
        'x:unknowns',
      },
    },
  }

  config_util.map_n('<leader>tb', ':TagbarOpen jc<cr>')
end

function M.vim_angry_reviewer()
  config_util.set_variables {
    AngryReviewerEnglish = 'american'
  }

  config_util.map_n('<leader>ar', ':AngryReviewer<cr>')
end

function M.vim_test()
  config_util.set_variables {
   ['test#strategy'] = "vimux",
   ['test#python#runner'] = 'nose',
   ['test#python#nose#options'] = { nearest = '-sv --config /dev/null' },
  }
  config_util.map_n('<leader>rt', ':TestNearest<cr>')
  config_util.map_n('<leader>rT', ':TestFile<cr>')
end

function M.black_python()
  config_util.set_variables {
    black_linelength = 120,
    black_virtualenv = "~/.local/share/nvim/black",
  }
end

function M.vim_clang_format()
  config_util.set_variables { ['clang_format#detect_style_file'] = 1, }
end

function M.nvim_mini_yank()
  vim.cmd([[ map p <Plug>(miniyank-autoput) ]])
  vim.cmd([[ map P <Plug>(miniyank-autoPut) ]])
end

function M.enable_spelunker(...)
  local words = {}
  for _, path in pairs({...}) do
    for _, local_word in pairs(vim.fn.readfile(path)) do
      table.insert(words, local_word)
    end
  end

  config_util.set_variables {
    enable_spelunker_vim = 1,
    spelunker_white_list_for_user = words,
  }
end

function M.python_black_format()
  vim.cmd([[ :PyImportSortCDM ]])
  vim.cmd([[ :w!              ]])
  vim.cmd([[ :Black           ]])
end

function M.nvim_colorizer()
  vim.opt.termguicolors = true
  require'colorizer'.setup()
end

function M.vim_lastplace()
  config_util.set_variables {
    lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit",
    lastplace_ignore_buftype = "quickfix,nofile,help",
  }
end

function M.general_plugin_config()
  M.black_python()
  M.indentline()
  M.nerd_commenter()
  M.nvim_colorizer()
  M.spelunker_vim()
  M.tagbar()
  M.train_nvim()
  M.vim_better_whitespace()
  M.vim_clang_format()
  M.vim_localvimrc()
  M.vim_lastplace()
  M.vim_markdown()
  M.vim_test()
  M.vim_angry_reviewer()
end

function M.plugin_config()
  M.general_plugin_config()

  require('yen3.git').setup()
  require('yen3.diagnostic').setup()
  require('yen3.status_line').setup()
  require('yen3.search').setup()
  require('yen3.lsp').setup()
  require('yen3.treesitter').setup()

  vim.cmd([[ source ~/.config/nvim/vim/plugin.vim ]])

  M.nvim_mini_yank()
end

function M.setup()
  M.packer()
  M.plugin_config()
end

return M
