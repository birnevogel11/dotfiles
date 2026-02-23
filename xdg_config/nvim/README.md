# Neovim config

- The setting is only for neovim.
- It requires neovim 0.10 or nightly.

## Memo

- Install tree-sitter binary:

```bash
mise install github:tree-sitter/tree-sitter
mise use -g github:tree-sitter/tree-sitter
```

## Profile startup time

```bash
nvim --startuptime startuptime.log "+qa" && cat ./startuptime.log
```
