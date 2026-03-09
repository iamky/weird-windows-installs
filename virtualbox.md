1. get the win iso

2.this step is only required if u want to install windows in specific partition. 
if u want to install windows on an entire drive you can skip cuz whole thing will be wiped anyway

make the location by resize or shrink the disk to make a partition using gparted
make a NTFS partition out of free space u claimed

3. install virtualbox

4. create a vmdk file by command
   sudo vboxmanage internalcommands createrawvmdk -filename sda.vmdk -rawdisk /dev/sda

   #NOTE this command is retired </3 idk how it worked for me lol

5.change ownership of the VMDK files to your user
  sudo chown "$USER:" *.vmdk
  
6.allow user temporary access to the disk group
  sudo usermod -aG disk "$USER"
  newgrp disk

7. start virtualbox

8. create a new vm
   select iso
   check unattended install if u dont wanna setup windows
   if u wanna jus leav it unchecked

9. SELECT use an existing vmdk virtual hard disk file and find the one u created

10. boot vm
    if u didnt unattend setup windows normally till u in the desktop
    if u did it will automatically setup

    NOTE: SOMETIMES WINDOWS GETS IN ITS FEELINGS
    SO, after windows install finishes it will reboot from setup power off the vm before it does

    THIS step ensures that u can setup windows oobe yourself I HOWEVER DONT DO THIS IDK Y

11. delete the vm if u wanna but i dont till i double check lol
12. exit virtual box and remove user from disk group by this command
13. sudo deluser "$USER" disk

14. handle os-prober in grub and then mkconfig grub command u can google it


15. IF EVERTHING WENT OK GRUB WILL DETECT THE OS AND U CAN BE HAPPY
16. if it dont detect try reboot maybe it will boot
17. gg 
