xinit-config
============

xinitrc config files (host specific)

## Installation

Clone this repo:

```bash
git clone https://github.com/pschmitt/xinit-config.git $XDG_CONFIG_DIR/xinit
```

Link to it:

```bash
ln -s $XDG_CONFIG_DIR/xinit/xinitrc ~/.xinitrc
```

## Per host onfiguration

Create a new file called `xinitrc_$HOST`, the xinitrc script will source it.

