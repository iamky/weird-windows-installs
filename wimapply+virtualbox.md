this one combines wimlib's WIMAPPLY command and VIRTUALBOX

get windows iso
extract it
find install.wim 
get its info with "wiminfo install.wim" command

create partition (in virtualbox method u can use a disk however here u have to make a partition according to windows requirements like efi recovery msr and main)
just create a main partition first maybe? i never tested i dont remember

then use same old winapply and again i use index 1 as example u can use wiminfo for correct index for the version u desire
sudo wimapply install.wim 1 /dev/sda3

to make it bootable
get virtal box
make a vmdk for physical partition

sudo vboxmanage internalcommands createrawvmdk -filename sda3.vmdk -rawdisk /dev/sda -partitions 3

NOTE: OH WOULD U LOOK AT THAT IT WE CAN MAKE PARTITIONS FOR A DISK IN VIRTUAL HDD WITH VM wtf is this black magic

change ownership to urself
sudo chown "$USER:" *.vmdk

give temp access to disk group
sudo usermod -aG disk "$USER"
newgrp disk

start virtual box
create new vm
select iso
check skip unattend if u dont this shit will nuke the whole generation i mean whole drive 
select use an existing virtual hard disk file and find the vmdk we made with command

boot the vm to install setup now DONT install WINDOWS 
u need to CLICK REPAIR YOUR COMPUTER button BELOW INSTALL at left hand corner
then click troubleshoot then command prompt

NOW WE IN CMD

get the letter for ur windows install partition where we WIMAPPLY the wim file
the commands are
diskpart
list disk
#list disk will give number for disks find the one where is ur partition
sel disk [number]
list partition
#just like above this will show number find the one where u installed windows
sel partition [number]
detail partition
#then assign it a letter if its blank by this command NOTE: YOU CAN ASSIGN ANY LETTER U WANT BUT ITS GOTTA BE UNUSED
assign letter C
#then detail again
and check the letter is assigned and its active (active thing is for mbr and old systems)
exit

NOW IN CMD
check for err
chkdsk c: /f

make the boot sector
bootrec /fixboot

make boot files for windows
cd X:\windows\system32
bcdboot.exe C:\Windows /s C: /f ALL

NOTE: the "X:\" directory is for the iso mount point where setup is running
it can change depending on system so be sure to check and change it accordingly
SAME for "C:\" as we named it just above so use that letter that u assigned

the output for this should be
"Boot files successfully created."

exit

turn off the pc by canceling setup and shutting down vm

delete vm if u want to
remove user from diskgroup
sudo deluser "$USER" disk

do the grub shenanigans like os prober and mkconfig

NOW GG
