# 🚀 Agos09's Dotfiles

My personal development environment, managed with [chezmoi](https://www.chezmoi.io/). Designed to work seamlessly on **Ubuntu** and **Arch Linux**.

## 🛠️ Quick Infrastructure
- **Shell**: Bash (Modularized)
- **Editor**: Neovim / Doom Emacs
- **Terminal**: Kitty
- **Multiplexer**: Zellij
- **Prompt**: Starship

## 📦 Installation (New Machine)
To bootstrap a new machine, ensure `curl` and `git` are installed, then run:
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Agos09
