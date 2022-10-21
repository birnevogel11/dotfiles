local latex_box_setup = function()
  require('yen3.util.config').set_variables {
    LatexBox_latexmk_preview_continuously = 1,
    LatexBox_viewer = 'open -a /Applications/Skim.app',
    LatexBox_latexmk_options = "-pdflatex='xelatex -file-line-error -shell-escape -synctex=1'",
  }
  vim.cmd [[ let $PATH .= ":/Library/TeX/texbin" ]]
  vim.cmd [[ autocmd Filetype tex noremap  <silent><leader>ll :silent !/Applications/Skim.app/Contents/SharedSupport/displayline
  \ <C-R>=line('.')<cr> "<C-R>=LatexBox_GetOutputFile()<cr>" "%:p" <cr> ]]
  vim.cmd [[ autocmd Filetype tex noremap <silent><F5> :Latexmk<cr> ]]
end

local latex_setup = function()
  require('yen3.util.ftplugin').indention_setup(2, 80)

  vim.opt_local.spell = true
  vim.opt_local.cole = 0

  latex_box_setup()
end

latex_setup()
