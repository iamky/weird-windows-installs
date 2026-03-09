booting from grub

get the iso

get wimboot https://github.com/ipxe/wimboot
get imdisk https://github.com/LTRData/ImDisk

make a ntfs data partition 
copy iso in root there
extract wimboot and copy wimboot file to root
extract imdisk file and save the extracted folder in the root

add a grub entry to boot windows iso with wimboot
menuentry "Win-iso wimboot" --class windows11 {
insmod part_msdos
insmod ntfs
set root='hd0,msdos3'
loopback loop /Win11.ISO
linux16 /wimboot
initrd16 \
newc:bcd:(loop)/boot/bcd \
newc:boot.sdi:(loop)/boot/boot.sdi \
newc:boot.wim:(loop)/sources/boot.wim
boot
}

and update grub config

boot this entry from grub
this will open windows setup 
open REPAIR YOUR COMPUTER from install page
click troubleshoot then command prompt

in cmd type
notepad
then press ctrl+o
show all files instead of just txt
use the explorer window to navigate to ntfs partition root where we put all the files
open imdisk folder
right click on imdisk.inf and select install
after install find the iso file
right click and mount by imdisk as a virtual disk

now in explorer find the mounted iso in form of a disk drive
open it there would be setup.exe
right click it and open 

AND INSTALL WINDOWS NORMALLY

https://rmprepusb.com/tutorials/145-install-windows-directly-from-an-iso-file-using-ipxe-wimboot-mbruefi-grub2grub4dos/

IF IT FAILS
use \sources\setupprep.exe

or use dism with manual method from here
