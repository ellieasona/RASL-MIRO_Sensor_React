#!/bin/bash
#	@file
#	@section COPYRIGHT
#	Copyright (C) 2018 Consequential Robotics (CqR)
#	
#	@section AUTHOR
#	Consequential Robotics http://consequentialrobotics.com
#	
#	@section LICENSE
#	For a full copy of the license agreement, see LICENSE.MDK in
#	the MDK root directory.
#	
#	Subject to the terms of this Agreement, Consequential Robotics
#	grants to you a limited, non-exclusive, non-transferable license,
#	without right to sub-license, to use MIRO Developer Kit in
#	accordance with this Agreement and any other written agreement
#	with Consequential Robotics. Consequential Robotics does not
#	transfer the title of MIRO Developer Kit to you; the license
#	granted to you is not a sale. This agreement is a binding legal
#	agreement between Consequential Robotics and the purchasers or
#	users of MIRO Developer Kit.
#	
#	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#	OTHER DEALINGS IN THE SOFTWARE.
#	
#	@section DESCRIPTION
#	
#	This script is called to control the current state and autostart
#	state of the bridge, as well as to return the current status.
#

# localise
FILE_TMP=/tmp/user_ready.sh
FILE_AUTOSTART=/home/root/bin/user_ready.sh
if [[ ! -e $FILE_AUTOSTART ]]; then
	# might be running on dev machine
	FILE_AUTOSTART=user_ready.sh
fi

# check if bridge is running
if [[ ! `ps cax | grep miro_bridge` == "" ]];
then
	BRIDGE_RUNNING=1
else
	BRIDGE_RUNNING=0
fi

# check autostart state
IS_DISABLED=`cat $FILE_AUTOSTART | grep "#start_bridge.sh"`
if [[ "$IS_DISABLED" == "" ]]; then
	BRIDGE_AUTOSTART=1
else
	BRIDGE_AUTOSTART=0
fi

# handle argument
case $1 in
	"toggle_running")
		if [[ "$BRIDGE_RUNNING" == "0" ]];
		then
			# start bridge
			/home/root/bin/start_bridge.sh
			touch /tmp/in
			pwd > /home/root/pwd.log
			./start_user.sh &> /home/root/bridgeinitator.log
			touch /tmp/out
			BRIDGE_RUNNING=1
		else
			# stop bridge
			touch /tmp/ctrl/miro_bridge.stop || exit 1
			BRIDGE_RUNNING=0
		fi
		;;
	"toggle_autostart")
		if [[ "$BRIDGE_AUTOSTART" == "0" ]];
		then
			cat $FILE_AUTOSTART | sed s/^#start_bridge.sh/start_bridge.sh/ > $FILE_TMP || exit 1
			cp $FILE_TMP $FILE_AUTOSTART || exit 1
			rm $FILE_TMP
			BRIDGE_AUTOSTART=1
		else
			cat $FILE_AUTOSTART | sed s/^start_bridge.sh/#start_bridge.sh/ > $FILE_TMP || exit 1
			cp $FILE_TMP $FILE_AUTOSTART || exit 1
			rm $FILE_TMP
			BRIDGE_AUTOSTART=0
		fi
		;;
esac

# return state
if [[ "$BRIDGE_RUNNING" == "1" ]];
then
	if [[ "$BRIDGE_AUTOSTART" == "1" ]];
	then
		echo "running (autostart enabled)"
	else
		echo "running (autostart disabled)"
	fi
else
	if [[ "$BRIDGE_AUTOSTART" == "1" ]];
	then
		echo "not running (autostart enabled)"
	else
		echo "not running (autostart disabled)"
	fi
fi




