killall bindfs || true

# Shells
rm  ~/.local/share/fish/fish_history || true
rm  ~/.config/fish/config.fish  || true

# Default
rm -R ~/Documents || true
rm -R ~/Applications || true
rm -R ~/Downloads || true
rm -R ~/Pictures || true
rm -R ~/Videos || true
rm -R ~/Projects || true
rm -R ~/.config/certs || true
rm -R ~/.config/vpn || true
rm -R ~/.config/sops || true
rm -R ~/.local/share/keyrings || true
rm -R ~/.local/share/applications || true
rm -R ~/.local/share/desktop-directories || true
rm -R ~/.aws || true
rm -R ~/.ssh || true
rm -R /var/lib/libvirt/images || true

# Apps
# Chrome
rm -R ~/.config/google-chrome-beta || true
# VSCode
rm -R ~/.config/Code || true
rm -R ~/.vscode || true
# VSCode-Insiders
rm -R ~/.config/Code - Insiders || true
rm -R ~/.vscode-insiders || true
# 1Password
rm -R ~/.config/1Password || true
# Obsidian
rm -R ~/.config/obsidian || true
# Signal
rm -R ~/.config/Signal || true
# Firefox
rm -R ~/.mozilla || true
rm -R ~/.mozilla-beta || true
# WebCord
rm -R ~/.config/WebCord || true
# Nacivat
rm -R ~/.config/navicat || true
# k8sManagment
rm -R ~/.config/k9s || true
# Btop
rm -R ~/.config/btop || true
# Coder
rm -R ~/.config/coderv2 || true
rm -R ~/.config/vivaldi || true
rm -R ~/.config/idasen || true
# Gaming
rm -R ~/.local/share/"Paradox Interactive" || true
rm -R ~/.cache/AMD || true
rm -R ~/.cache/mesa_shader_cache || true
rm -R ~/.paradoxlauncher || true
rm -R ~/.config/unity3d || true
rm -R ~/.local/share/Steam || true

# Features
rm -R ~/.gnupg || true
rm -R ~/.config/Yubico || true

rm  ~/.local/share/fish/fish_history || true
rm  ~/.config/fish/config.fish  || true


# Manual remove after first fail
# rm -R ~/.gnupg/private-keys-v1.d || true



# echo "Check Yubikey" && git add . && sudo nixos-rebuild switch --flake .#gza
