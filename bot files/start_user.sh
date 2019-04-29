#!/bin/bash


echo "PID of this script: $$"

source /home/root/.bashrc
source /home/root/.profile
source /opt/ros/kinetic/setup.bash                                  
                                                                    
# add our bits of ROS setup                                         
ROS_PACKAGE_PATH=$MIRO_PATH_MDK/share:$ROS_PACKAGE_PATH             
PYTHONPATH=$MIRO_PATH_MDK/share:$PYTHONPATH                         
PYTHONPATH=/opt/ros/catkin_pkg/src:$PYTHONPATH                      
                                                                    
# needed for roswtf at jade, I think, because yocto is unknown      
export ROS_OS_OVERRIDE=ubuntu 


python /home/root/Initiator.py &> /tmp/initiator.log
