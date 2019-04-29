from PrimaryHandler import *
import signal
import sys
import os

def terminate_process(signalNumber, frame):
    rospy.signal_shutdown("SIGTERM received")
    print("SIGTERM terminating process")
    sys.exit()


if __name__ == "__main__":
    print("My PID is: ", os.getpid())
    signal.signal(signal.SIGTERM, terminate_process)
    rospy.init_node('Demo', anonymous=True)
    robot = SecondaryInterface('rob01', 1, 6.283185307 / 2)
    robot.sensorinterrupt()

