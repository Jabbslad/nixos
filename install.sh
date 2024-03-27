#!bash
set -euxo pipefail

dir=$(pwd)
homemanager="$HOME/.config/home-manager"

sudo ln -sf "$dir/configuration.nix" /etc/nixos
# sudo ln -sf "$dir/hardware-configuration.nix" /etc/nixos

echo "making $homemanager"
mkdir -p "$homemanager"
ln -sf "$dir/home.nix" "$homemanager"
