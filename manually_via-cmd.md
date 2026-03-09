#Boot into windows installation then follow 

#as soon as windows installer boots
Shift + F10 

#in CMD type

diskpart  
list disk

#from list disk check in which u wanna install
sel disk number

#this shit will wipe everything careful bro
clean

#again
sel disk 

#gpt format cuz mbr old now
conv gpt

#for efi boot partition
create par efi size=512
format fs=fat32
assign letter B

#for ms reserved thingy
create partition msr size=16

#primay where windows stays
create par pri
#we shrink this for recovery its optional 
shrink minimum=1024
format quick fs=ntfs label="Windows"
assign letter C

#for recovery
create partition primary
format quick fs=ntfs label="Recovery"
assign letter R
set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
gpt attributes=0x8000000000000001

#check u did everything right
list volume

#if u did 
exit
#else
retry from start

#we gon use dism tool to apply image its built in windows setup so dont leave cmd yet
#first get info if your install media contains what typa shit u need to install by this command
#also its not necessary u will have D drive for ur usb so open NOTEPAD in cmd press ctrl+o go to this pc check which letter is assigned to ur install media usb use that instead of D
dism /Get-ImageInfo /imagefile:D:\sources\install.wim

#the above will output whole lotta shit like name index for identification choose ur pokemon i mean version of windows then remember the index cuz its used in next command here i use index 1 as example check yours also again check for letter cuz it wont be D and replace it
dism /Apply-Image /ImageFile:D:\Sources\install.wim /index:6 /ApplyDir:C:\

#now for recovery which is optional this had 3 commands and uses files from C
mkdir R:\Recovery\WindowsRE
xcopy /h C:\Windows\System32\Recovery\Winre.wim R:\Recovery\WindowsRE
C:\Windows\System32\Reagentc /setreimage /path R:\Recovery\WindowsRE /target C:\Windows

#VERY IMPORTANT this is for boot files without this shit all of that is useless REMEBER the shit we made in first step the EFI in B well here u go 
bcdboot C:\Windows /s B: /f ALL
exit

#if shit worked out for u good if it didnt well gg try another bro lol
