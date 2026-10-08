# /etc/zprofile (path_helper) runs after .zshenv and shoves /usr/bin to the
# front. Put ours back on top.
path=($HOME/.local/bin $path)
