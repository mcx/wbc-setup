#!/bin/bash

# Get this script's path
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

set -e

source $SCRIPTPATH/fun.cfg

# Check ubuntu version and select the right ROS
UBUNTU=$(lsb_release -cs)
if   [ $UBUNTU == "bionic" ]; then
	ROS_DISTRO=melodic
elif [ $UBUNTU == "xenial" ]; then
	ROS_DISTRO=kinetic
else
	echo -e "${COLOR_WARN}Wrong Ubuntu! This code runs on Ubuntu 16.04 or 18.04${COLOR_RESET}"
fi
# Remove APT cache and update the sources
sudo rm -rf /var/lib/apt/lists/*

# Add xbot debian server to the sources
sudo sh -c 'echo "deb http://xbot.cloud/repo/ /" > /etc/apt/sources.list.d/xbot-latest.list'
wget -q -O - http://xbot.cloud/repo/KEY.gpg | sudo apt-key add -

# Add ROS debian server to the sources
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros-latest.list'
wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | sudo apt-key add -

# APT update
sudo apt-get update

# Install SYSTEM libraries
echo -e "${COLOR_INFO}Install SYSTEM libraries${COLOR_RESET}"
cat $SCRIPTPATH/config/sys_deps_list.txt | grep -v \# | xargs sudo apt-get install -y

# Install ROS libraries
echo -e "${COLOR_INFO}Install ROS packages${COLOR_RESET}"
cat $SCRIPTPATH/config/ros_deps_list.txt | grep -v \# | xargs printf -- "ros-${ROS_DISTRO}-%s\n" | xargs sudo apt-get install -y

# Install XBOT libraries
echo -e "${COLOR_INFO}Install XBOT packages${COLOR_RESET}"
cat $SCRIPTPATH/config/xbot_deps_list.txt | grep -v \# | xargs sudo apt-get install -y

sudo ldconfig

sudo rosdep init
rosdep update

echo -e "${COLOR_INFO}Install WBC debian packages${COLOR_RESET}"
sudo dpkg -i ./debs/*.deb

# Setup Bashrc
if grep -Fwq "/opt/ros/${ROS_DISTRO}/setup.bash" ~/.bashrc
then 
 	echo -e "${COLOR_INFO}Bashrc already updated with ROS setup.bash, skipping this step...${COLOR_RESET}"
else
    	echo -e "${COLOR_INFO}Update the bashrc with ROS setup.bash .${COLOR_RESET}"
	echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
fi

if grep -Fwq "/opt/xbot/setup.bash" ~/.bashrc
then 
 	echo -e "${COLOR_INFO}Bashrc already updated with XBOT setup.bash, skipping this step...${COLOR_RESET}"
else
	echo -e "${COLOR_INFO}Add setup scripts in /opt/xbot/${COLOR_RESET}"
	# Copy environment setup script
	sudo cp xbot_setup.sh.ini /opt/xbot/setup.sh
	sudo cp xbot_setup.sh.ini /opt/xbot/setup.bash
	# Empty .catkin file is needed to find executables
	sudo touch /opt/xbot/.catkin
    	echo -e "${COLOR_INFO}Update the bashrc with XBOT setup.bash.${COLOR_RESET}"
	echo "source /opt/xbot/setup.bash" >> ~/.bashrc
fi

exit 0
