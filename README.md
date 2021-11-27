## Whole-body locomotion framework for quadruped robots

<p float="center">
  <img src="docs/hyq.gif" width="250" height="185" />
  <img src="docs/anymal.gif" width="250" height="185" /> 
  <img src="docs/aliengo.gif" width="250" height="185" />
  <figure>
    <figcaption>Left to right: HyQ, AnYmal and Aliengo.</figcaption>
  </figure>
</p>

This repo contains the debian packages of the whole body controller presented in the following [paper](https://hal.archives-ouvertes.fr/hal-03005133/document): 

```
@article{raiola2020simple,
  title={A simple yet effective whole-body locomotion framework for quadruped robots},
  author={Raiola, Gennaro and Mingo Hoffman, Enrico and Focchi, Michele and Tsagarakis, Nikos and Semini, Claudio},
  journal={Frontiers in Robotics and AI},
  volume={7},
  pages={159},
  year={2020},
  publisher={Frontiers}
}
```

If you or your organization are interested in the source code, please send an email to gennaro.raiola(AT)gmail.com

## How to run the code

You can run the code either by installing it on your machine, or by running it in a docker container.

### Docker container for Ubuntu 16.04 and 18.04

First you need docker running on your computer. If you need to install docker from scratch, run the following script:

`./install_docker.sh`

Note: it could be necessary to restart the computer after the installation.

When docker is ready and running you can pull the docker image from [docker-hub](https://hub.docker.com/):

+ Run `docker pull serger87/wbc:bionic` to download the bionic image.
+ Run `docker tag serger87/wbc:bionic wbc:bionic` to rename the image.
+ Finally you can launch the controller in the docker environment: `./run_docker.sh`

You can see the avaialbe options with `./run_docker.sh --help`

Note: use the `install_nvidia.sh` script if you are experiencing the following problem: `could not select device driver "" with capabilities: [[gpu]]`. If you are experiencing this problem `nvidia-container-cli initialization error nvml error driver not loaded`, it probably means that your computer does not have the latest nvidia-drivers installed. So be sure to install/update them.

### System installation for Ubuntu 18.04

Clone this repository:

`git clone git@github.com:graiola/wbc-setup.git`

Note: git-lfs is needed to correctly clone the debian packages in the debs folder.

To install the required dependencies (including ROS) and the wbc debian packages for Ubuntu 18.04 run the following:

`./install_dependencies.sh`

To launch the controller:

`roslaunch wb_controller wb_controller_bringup.launch`

## How to start the controller

To move the robot around you need a joypad plugged in. Press the `start` button when ready. The joypad commands are reported in the image below:

### Joypad commands

<p align="center"> 
<img src="docs/joy_commands.png">
</p>

## Legal notes

This work is licensed under a [license]("http://creativecommons.org/licenses/by-nc-nd/4.0/") Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License</a>.
![2](https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png)
