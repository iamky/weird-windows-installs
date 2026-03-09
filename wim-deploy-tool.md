here is cool lil project i found when back a while ago which does the same thing but is kinda complicated and err prone

https://codeberg.org/regnarg/deploy-win10-from-linux/
here is a guide how to use it for archive and ease of use ill just copy necessary shit here
https://codeberg.org/regnarg/deploy-win10-from-linux/issues/1

it has a fork!! here https://github.com/mhkarimi1383/windeploy-linux

Necessary system packages
libparted-dev (to use python-parted)
ms-sys
wimtools (for wimapply)

Necessary python packages

clize
construct
python-parted

############## NOTE ###############
If anyone sees this and is terribly confused as to why every usage of the parted module is "incorrect," despite trial and erroring half the code until the errors disappear,
There are two parted modules for Python:
python-pyparted
python-parted
This project uses the first one, not python-parted from pip.
############## NOTE ###############


sudo -i
python -m venv deploy-win10-from-linux-venv
source deploy-win10-from-linux-venv/bin/activate
pip install --upgrade pip
pip install clize construct python-parted

wiminfo install.wim

Running the script these are the required arguments:

--iso or --wim
--image-name
--disk or --part

python /home/user/workspace/personal/deploy-win10-from-linux/setup_win10.py --iso /home/user/Desktop/tmp-windows-10/Win10_22H2_English_x64v1.iso --image-name "Windows 10 Pro" --part /dev/sdc1

Set boot flag on NTFS partition
Lastly, using GParted set the boot flag on the NTFS partition, otherwise Windows wouldn't boot: In GParted, right-click the partition > Manage Flags > make sure boot is checked > Close
