DISK=/dev/nvme0n1
SWAP_SIZE=16G

set -e

######################
# Partition the disk #
######################
#parted $DISK -- mklabel gpt
#parted $DISK -- set 1 esp on
#parted $DISK -- mkpart primary 512MiB 100%

##################################################
# Setup the encrypted LUKS partition and open it #
##################################################

#cryptsetup --verify-passphrase -v luksFormat "$DISK"p2
#cryptsetup config "$DISK"p2 --label cryptroot
#cryptsetup luksOpen "$DISK"p2 enc-pv

###############
# Create LV's #
###############

pvcreate /dev/mapper/enc-pv
vgcreate vg /dev/mapper/enc-pv
lvcreate -L $SWAP_SIZE -n swap vg
lvcreate -l '100%FREE' -n root vg

#####################
# Format Partitions #
#####################

mkfs.fat -F 32 -n boot "$DISK"p1
mkswap -L swap /dev/vg/swap
swapon /dev/vg/swap
mkfs.btrfs -L root /dev/vg/root

#####################
# Create subvolumes #
#####################
mount -t btrfs /dev/vg/root /mnt

# We first create the subvolumes outlined above:
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/log

# We then take an empty *readonly* snapshot of the root subvolume,
# which we'll eventually rollback to on every boot.

btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

umount /mnt

#########################
# Mount the directories #
#########################

mount -o subvol=root,compress=zstd,noatime,ssd,space_cache=v2 /dev/vg/root /mnt
mkdir -p /mnt/{persist,nix,var/log}
mount -o subvol=persist,compress=zstd,noatime,ssd,space_cache=v2 /dev/vg/root /mnt/persist
mount -o subvol=nix,compress=zstd,noatime,ssd,space_cache=v2 /dev/vg/root /mnt/nix
mount -o subvol=log,compress=zstd,noatime,ssd,space_cache=v2 /dev/vg/root /mnt/var/log

# Mount boot partition
mkdir /mnt/boot
mount "$DISK"p1 /mnt/boot

echo "All good"

# nixos-generate-config --root /mnt
