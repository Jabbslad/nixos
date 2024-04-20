#!bash
set -euxo pipefail

dir=$(pwd)
homemanager="$HOME/.config/home-manager"

sudo cp -v "$dir/configuration.nix" /etc/nixos
# sudo ln -sf "$dir/hardware-configuration.nix" /etc/nixos

echo "making $homemanager"
mkdir -p "$homemanager"
cp -Rvf $dir/home-manager/* "$homemanager"
