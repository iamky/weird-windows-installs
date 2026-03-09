#!/bin/bash
set -e

# TO RUN this file
#chmod +x wim-apply.sh
#sudo ./wim-apply.sh


# FOR LINUX
# THIS KINDA WORKS ON MACOS TOO BUT NEED A FEW CHANGES 
 
# your drive and ISO
# get disk name by lsblk
DISK="/dev/[drivename goes here]"
ISO="[iso path here]"
UNATTEND="path/to/autounattend.xml"

# packages needed cuz i use arch btw u can edit or find it according to ur distro
echo "Installing required packages..."
sudo pacman -Sy --noconfirm wimlib ntfs-3g gptfdisk parted dosfstools sgdisk
 
# partition sizes in MiB
#EFI_SIZE=512
#MSR_SIZE=16
#REC_SIZE=1024


#OLD CODE I KEEP AROUND

# calculate positions to dynamically assign size for primary to be largest
#EFI_START=1
#EFI_END=$((EFI_START + EFI_SIZE))       # 1–513
#MSR_START=$EFI_END
#MSR_END=$((MSR_START + MSR_SIZE))       # 513–529
#WIN_START=$MSR_END
#REC_END=$(( $(blockdev --getsize64 $DISK) / 1024 / 1024 ))  # total MiB
#WIN_END=$((REC_END - REC_SIZE))         # windows goes up to Recovery
#REC_START=$WIN_END                       # recovery partition start
 
#echo "Creating GPT partitions..."
#sudo parted $DISK --script \
#mklabel gpt \
#mkpart EFI fat32 ${EFI_START}MiB ${EFI_END}MiB \
#set 1 esp on \
#mkpart MSR ${MSR_START}MiB ${MSR_END}MiB \
#mkpart Windows ntfs ${WIN_START}MiB ${WIN_END}MiB \
#mkpart Recovery ntfs ${REC_START}MiB ${REC_END}MiB

echo "Wiping disk..."
wipefs -a $DISK
sgdisk --zap-all $DISK

# OPTIONAL BETWEEN PARTED OR SGDISK
#EFI_SIZE=512
#MSR_SIZE=128
#REC_SIZE=1024
#echo "Creating GPT layout"
#sgdisk -n1:1MiB:+${EFI_SIZE}MiB -t1:EF00 -c1:"EFI System" $DISK
#sgdisk -n2:0:+${MSR_SIZE}MiB -t2:0C01 -c2:"Microsoft reserved" $DISK
#sgdisk -n3:0:-${REC_SIZE}MiB -t3:0700 -c3:"Windows" $DISK
#sgdisk -n4:0:0 -t4:2700 -c4:"Windows Recovery" $DISK

#echo "Creating GPT layout..."
#parted -s $DISK mklabel gpt
#echo "Creating partitions..."
# EFI
#parted -s $DISK mkpart EFI fat32 1MiB 513MiB
#parted -s $DISK set 1 esp on
# MSR
#parted -s $DISK mkpart MSR 513MiB 641MiB
# Windows (rest minus recovery)
#parted -s $DISK mkpart Windows ntfs 641MiB -1025MiB
# Recovery
#parted -s $DISK mkpart Recovery ntfs -1025MiB 100%

sleep 2

EFI="${DISK}1"
MSR="${DISK}2"
WIN="${DISK}3"
REC="${DISK}4"

echo "Formatting partitions..."
sudo mkfs.fat -F32 $EFI
sudo mkfs.ntfs -f $WIN
sudo mkfs.ntfs -f $REC

echo "Label the partitions..."
fatlabel $EFI SYSTEM
ntfslabel $WIN Windows
ntfslabel $REC Recovery
 
echo "Mounting ISO..."
sudo mkdir -p /mnt/winiso
sudo mount "$ISO" /mnt/winiso
 
#echo "Mounting Windows partition..."
#sudo mkdir -p /mnt/win
#sudo mount $WIN /mnt/win

echo "Mounting partitions..."
mkdir -p /mnt/win
mkdir -p /mnt/win/boot/efi
mount $WIN /mnt/win

echo "Applying Windows image..."
sudo wimapply /mnt/winiso/sources/install.wim 1 /mnt/win  # again i went with example index 1 u can use "wiminfo [path/to/install.wim]" to get info about your wim file

# TWO BOOTLOADER OPTIONS HAVENT TESTED THEM YET ILL UPDATE WHEN I TEST

#echo "Installing bootloader "
#bcdboot /mnt/windows/Windows /s /mnt/windows/boot /f UEFI

#echo "Installing bootloader 2..."
#mount $EFI /mnt/win/boot/efi
#mkdir -p /mnt/win/Windows/System32/config/systemprofile
#bcdboot /mnt/win/Windows /s /mnt/win/boot/efi /f UEFI || true

echo "Setting up WinRE"
mkdir -p /mnt/recovery
mount $REC /mnt/recovery
mkdir -p /mnt/recovery/Recovery/WindowsRE
cp /mnt/windows/Windows/System32/Recovery/Winre.wim \
/mnt/recovery/Recovery/WindowsRE/winre.wim || true

echo "Registering recovery environment"
mkdir -p /mnt/windows/Windows/System32/Recovery
cp /mnt/recovery/Recovery/WindowsRE/winre.wim \
/mnt/windows/Windows/System32/Recovery/Winre.wim || true

echo "Copying unattend..."
mkdir -p /mnt/win/Windows/Panther
cp $UNATTEND /mnt/win/Windows/Panther/unattend.xml

 
#echo "Applying unattend.xml for automatic setup..."
#sudo mkdir -p /mnt/win/Windows/Panther/Unattend
#sudo cp /path/to/unattend.xml /mnt/win/Windows/Panther/Unattend/unattend.xml
#sudo chmod 644 /mnt/win/Windows/Panther/Unattend/unattend.xml

#gives error sometimes when booting to windows can be fixed via startup repair
#echo "Setting up EFI boot structure..."
#sudo mkdir -p /mnt/win/boot/efi
#sudo mount $EFI /mnt/win/boot/efi
 
#sudo mkdir -p /mnt/win/boot/efi/EFI/Microsoft/Boot
#sudo mkdir -p /mnt/win/boot/efi/EFI/Boot
 
#sudo cp /mnt/win/Windows/Boot/EFI/bootmgfw.efi \
#/mnt/win/boot/efi/EFI/Microsoft/Boot/
 
#sudo cp /mnt/win/Windows/Boot/EFI/bootmgfw.efi \
#/mnt/win/boot/efi/EFI/Boot/bootx64.efi

umount /mnt/recovery
umount /mnt/windows/boot
umount /mnt/windows
 
echo "Done gang restart this bitch"
