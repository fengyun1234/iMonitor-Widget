export THEOS_DEVICE_IP=192.168.0.3
SDKVERSION = 5.0
include theos/makefiles/common.mk

LIBRARY_NAME = iMonitor
iMonitor_FILES = iMonitorWidget.mm UIDevice-Capabilities.m UIDevice-Hardware.m UIDevice-Orientation.m UIDevice-IOKitExtensions.m UIDevice-Reachability.m
iMonitor_INSTALL_PATH = /System/Library/WeeAppPlugins/WeeAppTest.bundle
iMonitor_FRAMEWORKS = UIKit CoreGraphics IOKit AVFoundation SystemConfiguration
iMonitor_PRIVATE_FRAMEWORKS = BulletinBoard

include $(THEOS_MAKE_PATH)/library.mk

after-stage::
	mv _/System/Library/WeeAppPlugins/WeeAppTest.bundle/iMonitor.dylib _/System/Library/WeeAppPlugins/WeeAppTest.bundle/iMonitor