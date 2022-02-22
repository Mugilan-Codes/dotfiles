# Mugilan's Dotfiles

## Needs Work

- Still need to be tested
- No idea it will work
- Setup Iterm2 first by downloading it directly from website.
- Setup Neovim and tmux (checkout alacritty)
- [Manage Multiple JDKs on Mac OS, Linux and Windows WSL2](https://medium.com/@brunoborges/manage-multiple-jdks-on-mac-os-linux-and-windows-wsl2-3a73467b685c)

```zsh
sudo softwareupdate -i -a
xcode-select --install
git clone git@github.com:Mugilan-Codes/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x fresh.sh
chmod +x bootstrap.sh
./bootstrap.sh
```

### Plan

1. Do Software update (possibly through command line).
1. Downlod Xcode Command line Tools. (also Xcode if needed).
1. Git Configuration and SSH
1. Clone the Dotfiles repo in ~/.dotfiles.
1. Install Oh-My-Zsh.

### TODO

- [ ] Generate and copy SSH keys for github
- [ ] Modify ./git/ignore file

#### Sources

- [What does >&2 mean in a shell script?](https://askubuntu.com/a/1182458)

##### Inspired from

- [Driesvints' Dotfiles](https://github.com/driesvints/dotfiles)
- [Webpro's Dotfiles](https://github.com/webpro/dotfiles)
