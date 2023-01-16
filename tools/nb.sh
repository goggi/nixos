rm  ~/.local/share/fish/fish_history || true
rm  ~/.config/fish/config.fish  || true

echo "Check Yubikey" && git add . && sudo nixos-rebuild switch --flake .#gza
