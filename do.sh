#!/bin/bash
make
mv -f ~/istatistic/obj/iMonitor.dylib ~/istatistic/iMonitor/System/Library/WeeAppPlugins/iMonitor.bundle/iMonitor
rm -rf ~/istatistic/obj/*.o 
dpkg-deb -b ~/istatistic/iMonitor
mv -f ~/istatistic/iMonitor.deb ~/Desktop/iMonitor.deb  