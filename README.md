# nixos

## Install

1. Boot into NIXOS Livecd
2. Open consol and setup partitions
```
sudo -i

export SWAP_SIZE=16G
export DISK=/dev/nvme0n1

# FIX PARTION

gdisk /dev/nvme0n1
o
y
n
enter
enter
512M
ef00
n
enter
enter
enter
8e00
w
Y

# FIX CRYPT

cryptsetup --verify-passphrase -v luksFormat "$DISK"p2
cryptsetup config "$DISK"p2 --label cryptroot
cryptsetup luksOpen "$DISK"p2 enc-pv

# CREATE PARTITIONS

pvcreate /dev/mapper/enc-pv
vgcreate vg /dev/mapper/enc-pv
lvcreate -L $SWAP_SIZE -n swap vg
lvcreate -l '100%FREE' -n root vg


mkfs.fat -F 32 -n boot "$DISK"p1
mkswap -L swap /dev/vg/swap
swapon /dev/vg/swap
mkfs.btrfs -L root /dev/vg/root

mount -t btrfs /dev/vg/root /mnt


btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/log
btrfs subvolume create /mnt/docker

btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

umount /mnt

mount -o subvol=root,compress=zstd,noatime,ssd,space_cache=v2 /dev/vg/root /mnt
mkdir -p /mnt/{persist,nix,var/log}
mount -o subvol=persist,compress=zstd,noatime,ssd,space_cache=v2 /dev/vg/root /mnt/persist
mount -o subvol=nix,compress=zstd,noatime,ssd,space_cache=v2 /dev/vg/root /mnt/nix
mount -o subvol=log,compress=zstd,noatime,ssd,space_cache=v2 /dev/vg/root /mnt/var/log

mkdir /mnt/boot
mount "$DISK"p1 /mnt/boot
```
3. Install 
```
nix-shell -p nixFlakes
sudo nixos-install --flake 'github:goggi/nixos#gza'
```


## Fix issues
1. Boot into NIXOS Livecd
2. Open consol and mount partitions
```
sudo cryptsetup luksOpen /dev/disk/by-label/cryptroot enc-pv

sudo mount -o subvol=root,compress=zstd,noatime,ssd,space_cache=v2 /dev/vg/root /mnt
sudo mount -o subvol=persist,compress=zstd,noatime,ssd,space_cache=v2 /dev/vg/root /mnt/persist
sudo mount -o subvol=nix,compress=zstd,noatime,ssd,space_cache=v2 /dev/vg/root /mnt/nix
sudo mount -o subvol=log,compress=zstd,noatime,ssd,space_cache=v2 /dev/vg/root /mnt/var/log
sudo mount /dev/disk/by-label/boot /mnt/boot
```
3. Add editor and open config
```
NIXPKGS_ALLOW_UNFREE=1 nix-shell -p vscode
code  /mnt/persist/home/gogsaan/Projects/private/nix/config
cd /mnt/persist/home/gogsaan/Projects/private/nix/config 
sudo nixos-install --flake .#gza
```

## Fix persist
```
sudo cp persist.tar /mnt/
sudo tar -xvf persist.tar 
```