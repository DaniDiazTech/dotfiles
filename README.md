# Dotfiles

These are my personal configuration files, used in Arch linux distributions.

Using bare repository to host my home configuration files.

Original idea and tutorial from [atlassian](https://www.atlassian.com/git/tutorials/dotfiles).

## Dependencies

Dependencies used in config files installed with a `yay` command:

```bash
yay -S exa bat neovim alacritty fish lxappearance visual-studio-code-bin
```

### Install shell prompt

Currently I'm using [Startship](https://starship.rs/guide/#%F0%9F%9A%80-installation).

*Run the following command in a bash shell*

```bash
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
```

## Set Up

*All of the following commands must be run on your home directory*

First, alias the `config` git command:

```bash
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
```

To avoid recursion problems:

```bash
echo "dotfiles" >> .gitignore
```

Now, clone the bare repository:

```bash
git clone --bare git@github.com:DaniDiazTech/dotfiles.git $HOME/dotfiles
```

Checkout the files to download them, and place them in your home directory:

```bash
config checkout
```

If you get an error like this:

```bash
error: The following untracked working tree files would be overwritten by checkout:
    .bashrc
Please move or remove them before you can switch branches.
Aborting
```

Make sure to back up the files git is pointing up before running the `checkout` command again.

```bash
mkdir ~/backup
mv .bashrc ~/backup
```

Finally run config checkout again:

```bash
config checkout
```
### Configure untracked files
To avoid showing every untracked file in the home directory, run:

```
config config --local status.showUntrackedFiles no
```
## Fish configuration

First, set the fish shell as default:

```bash
chsh -s /usr/bin/fish
```

Then, for comfortability, symlink the config file to my home directory (Just as the `.bashrc`).

```bash
ln -s  ~/.config/fish/config.fish ./config.fish
```
